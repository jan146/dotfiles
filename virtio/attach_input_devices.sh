DOMAIN="win10"
if [ $# -gt 0 ]; then
	DOMAIN=$1
fi
VIRTIO_DIR="$HOME/virtio"
echo "Domain: $DOMAIN"

for file in $VIRTIO_DIR/xml/*.xml
do
	sudo virsh detach-device --domain $DOMAIN --file "$file"
	sudo virsh attach-device --domain $DOMAIN --file "$file" 
done

#sudo virsh detach-device --domain $DOMAIN --file $VIRTIO_DIR/xml/input1.xml 
#sudo virsh attach-device --domain $DOMAIN --file $VIRTIO_DIR/xml/input1.xml 
#sudo virsh detach-device --domain $DOMAIN --file $VIRTIO_DIR/xml/input2.xml
#sudo virsh attach-device --domain $DOMAIN --file $VIRTIO_DIR/xml/input2.xml

