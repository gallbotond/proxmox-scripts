git clone https://github.com/wazuh/wazuh-docker.git -b v4.9.2

cd ./wazuh-docker/single-node

# Generate certs
docker compose -f generate-indexer-certs.yml run --rm generator

# Generate new password hash
docker run --rm -ti wazuh/wazuh-indexer:4.9.2 bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/hash.sh

# Change the password
nano config/wazuh_indexer/internal_users.yml