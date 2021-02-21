FROM faddat/sos-lite

# Add seeds and such after doing gaia.
# I will prototype the rest of this on gaia.
RUN echo nameservice > /etc/hostname && \
		pacman -Syyu --noconfirm docker-compose zerotier-one
#		echo "docker run johnreitano/nameservice" >> /usr/local/bin/firstboot.sh
# TODO: docker-compose
