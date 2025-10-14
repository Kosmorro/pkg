SKYFIELD_DATA_VERSION ?= $(shell pip show skyfield-data | grep Version | awk '{print $$2}')
KOSMORROLIB_VERSION ?= $(shell pip show kosmorrolib | grep Version | awk '{print $$2}')
KOSMORRO_VERSION ?= $(shell pip show kosmorro | grep Version | awk '{print $$2}')


clean:
	rm -rf *.deb


 #######################
###  DEBIAN PACKAGES  ###
 #######################

.PHONY: deb
deb: skyfield-data.deb kosmorrolib.deb kosmorro.deb

skyfield-data.deb:
	mkdir -p skyfield-data-deb/DEBIAN
	mkdir -p skyfield-data-deb/usr/bin
	mkdir -p skyfield-data-deb/usr/lib/python3/dist-packages

	pip install --target=tmp skyfield-data

	cp -r tmp/skyfield_data skyfield-data-deb/usr/lib/python3/dist-packages
	cp -r tmp/skyfield_data-$(SKYFIELD_DATA_VERSION).dist-info skyfield-data-deb/usr/lib/python3/dist-packages
	cp deb/skyfield-data/control skyfield-data-deb/DEBIAN/control

	sed -i "s/Version: __VERSION__/Version: $(SKYFIELD_DATA_VERSION)/" skyfield-data-deb/DEBIAN/control

	fakeroot dpkg-deb --build skyfield-data-deb
	mv skyfield-data-deb.deb python3-skyfield-data_$(SKYFIELD_DATA_VERSION)_all.deb

	rm -rf skyfield-data-deb tmp

kosmorrolib.deb:
	mkdir -p kosmorrolib-deb/DEBIAN
	mkdir -p kosmorrolib-deb/usr/bin
	mkdir -p kosmorrolib-deb/usr/lib/python3/dist-packages

	pip install --target=tmp kosmorrolib

	cp -r tmp/kosmorrolib kosmorrolib-deb/usr/lib/python3/dist-packages
	cp -r tmp/kosmorrolib-$(KOSMORROLIB_VERSION).dist-info kosmorrolib-deb/usr/lib/python3/dist-packages
	cp deb/kosmorrolib/control kosmorrolib-deb/DEBIAN/control

	sed -i "s/Version: __VERSION__/Version: $(KOSMORROLIB_VERSION)/" kosmorrolib-deb/DEBIAN/control

	fakeroot dpkg-deb --build kosmorrolib-deb
	mv kosmorrolib-deb.deb python3-kosmorrolib_$(KOSMORROLIB_VERSION)_all.deb

	rm -rf kosmorrolib-deb tmp


kosmorro.deb:
	mkdir -p kosmorro-deb/DEBIAN
	mkdir -p kosmorro-deb/usr/bin
	mkdir -p kosmorro-deb/usr/lib/python3/dist-packages

	pip install --target=tmp kosmorro

	cp -r tmp/kosmorro kosmorro-deb/usr/lib/python3/dist-packages
	cp -r tmp/kosmorro-$(KOSMORRO_VERSION).dist-info kosmorro-deb/usr/lib/python3/dist-packages
	cp tmp/bin/kosmorro kosmorro-deb/usr/bin/kosmorro
	cp deb/kosmorro/control kosmorro-deb/DEBIAN/control

	chmod +x kosmorro-deb/usr/bin/kosmorro
	sed -i 's/#!\/usr\/bin\/python/#!\/usr\/bin\/python3/' kosmorro-deb/usr/bin/kosmorro

	sed -i "s/Version: __VERSION__/Version: $(KOSMORRO_VERSION)/" kosmorro-deb/DEBIAN/control

	fakeroot dpkg-deb --build kosmorro-deb
	mv kosmorro-deb.deb kosmorro_$(KOSMORRO_VERSION)_all.deb

	rm -rf kosmorro-deb tmp