#!/bin/bash

BASE_DIR="/home/gns3/GNS3/projects"

if [ ! -d "$BASE_DIR" ]; then
    echo "Error: Directory $BASE_DIR not found."
    exit 1
fi

PROJECTS=()
while IFS= read -r -d $'\0' dir; do
    PROJECTS+=("$(basename "$dir")")
done < <(find "$BASE_DIR" -maxdepth 1 -mindepth 1 -type d -print0)

if [ ${#PROJECTS[@]} -eq 0 ]; then
    echo "No projects found in $BASE_DIR"
    exit 1
fi

echo "Available Projects:"
echo "-------------------"
for i in "${!PROJECTS[@]}"; do
    GNS3_FILE=$(ls "$BASE_DIR/${PROJECTS[$i]}"/*.gns3 2>/dev/null | head -n 1)
    PROJ_DISPLAY_NAME=$(basename "$GNS3_FILE" 2>/dev/null || echo "No .gns3 file")
    printf "[%2d] %-30s (Folder: %s)\n" "$((i+1))" "$PROJ_DISPLAY_NAME" "${PROJECTS[$i]}"
done

echo ""
read -p "Enter the number of the project: " PRO

if ! [[ "$PRO" =~ ^[0-9]+$ ]] || [ "$PRO" -lt 1 ] || [ "$PRO" -gt "${#PROJECTS[@]}" ]; then
    echo "Invalid selection. Exiting."
    exit 1
fi

SELECTED_FOLDER=${PROJECTS[$((PRO-1))]}
INPUT_FILE=$(ls "$BASE_DIR/$SELECTED_FOLDER"/*.gns3 2>/dev/null | head -n 1)

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Could not find a .gns3 file in $SELECTED_FOLDER"
    exit 1
fi

echo "Processing: $INPUT_FILE"
echo "-------------------------------------------------------"

jq -r '
  # Create map of ID to Name
  ((.topology.nodes // []) | map({(.node_id): (.name // "Unknown")}) | add) as $id2name |
  
  # Reference links
  (.topology.links // []) as $links |
  
  # Iterate nodes
  (.topology.nodes // [])[] | 
  .node_id as $this_id |
  .name as $this_name |
  
  ([
    $links[] | select(.nodes != null) | .nodes | 
    if .[0].node_id == $this_id then
      { "local": .[0], "remote": .[1] }
    elif .[1].node_id == $this_id then
      { "local": .[1], "remote": .[0] }
    else empty end |
    
    # Format port strings
    "[\(.local.label.text // ("port" + (.local.adapter_number | tostring) + "/" + (.local.port_number | tostring)))] -> \($id2name[.remote.node_id] // "Unknown") [\(.remote.label.text // ("port" + (.remote.adapter_number | tostring) + "/" + (.remote.port_number | tostring)))]"
  ] | join(", ")) as $connections |
  
  "\($this_name): \($connections | if . == "" then "none" else . end)"
' "$INPUT_FILE" | tee "Graph.txt"