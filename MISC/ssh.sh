
ssh \
-o KexAlgorithms=diffie-hellman-group1-sha1 \
-o HostKeyAlgorithms=ssh-rsa \
-o PubkeyAcceptedAlgorithms=ssh-rsa \
-o Ciphers=3des-cbc \
-o MACs=hmac-sha1 \
<TargetUser>@<targetIP>