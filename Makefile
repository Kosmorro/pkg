SKYFIELD_DATA_VERSION ?= $(shell pip show skyfield-data | grep Version | awk '{print $$2}')
KOSMORROLIB_VERSION ?= $(shell pip show kosmorrolib | grep Version | awk '{print $$2}')
KOSMORRO_VERSION ?= $(shell pip show kosmorro | grep Version | awk '{print $$2}')

DEBPKG_KEY_ID ?= ""


clean:
	rm -rf *.deb

	aptly publish drop main || true
	aptly snapshot drop main || true
	aptly repo drop main || true

	rm -rf ~/.aptly/public/
	rm -rf main repos tmp


packages: deb


repos: packages repo-apt


 #######################
###  DEBIAN PACKAGES  ###
 #######################

.PHONY: deb
deb: python3-skyfield-data.deb python3-kosmorrolib.deb kosmorro.deb


repo-apt:
	mkdir main && mv *.deb main
	aptly repo create main
	aptly repo add main main/
	aptly snapshot create main from repo main
	mkdir -p ~/.aptly/public
	aptly publish snapshot --architectures=all --distribution=main --gpg-key="$(DEBPKG_KEY_ID)" main

	rm -rf repos/apt

	mkdir -p repos
	cp -r ~/.aptly/public repos/apt
	mv repos/apt/dists/main repos/apt/dists/stable

	# Clean:
	aptly publish drop main
	aptly snapshot drop main
	aptly repo drop main

	rm -rf main


python3-skyfield-data.deb:
	mkdir -p skyfield-data-deb/DEBIAN
	mkdir -p skyfield-data-deb/usr/bin
	mkdir -p skyfield-data-deb/usr/share/doc/python3-skyfield-data
	mkdir -p skyfield-data-deb/usr/lib/python3/dist-packages

	pip install --target=tmp skyfield-data
	rm -rf tmp/skyfield_data/__pycache__

	cp -r tmp/skyfield_data skyfield-data-deb/usr/lib/python3/dist-packages
	cp -r tmp/skyfield_data-$(SKYFIELD_DATA_VERSION).dist-info skyfield-data-deb/usr/lib/python3/dist-packages
	cp deb/skyfield-data/control skyfield-data-deb/DEBIAN/control

	curl https://raw.githubusercontent.com/brunobord/skyfield-data/refs/tags/$(SKYFIELD_DATA_VERSION)/CHANGELOG.md | python deb/mkchangelogs.py python3-skyfield-data Deuchnord "jerome@deuchnord.fr" | gzip -9 > skyfield-data-deb/usr/share/doc/python3-skyfield-data/changelog.gz
	curl https://raw.githubusercontent.com/brunobord/skyfield-data/refs/tags/$(SKYFIELD_DATA_VERSION)/COPYING > skyfield-data-deb/usr/share/doc/python3-skyfield-data/copyright

	sed -i "s/Version: __VERSION__/Version: $(SKYFIELD_DATA_VERSION)/" skyfield-data-deb/DEBIAN/control

	fakeroot dpkg-deb --build skyfield-data-deb
	mv skyfield-data-deb.deb python3-skyfield-data_$(SKYFIELD_DATA_VERSION)_all.deb

	rm -rf skyfield-data-deb tmp

python3-kosmorrolib.deb:
	mkdir -p kosmorrolib-deb/DEBIAN
	mkdir -p kosmorrolib-deb/usr/bin
	mkdir -p kosmorrolib-deb/usr/share/doc/python3-kosmorrolib
	mkdir -p kosmorrolib-deb/usr/lib/python3/dist-packages

	pip install --target=tmp kosmorrolib
	rm -rf tmp/kosmorrolib/__pycache__

	cp -r tmp/kosmorrolib kosmorrolib-deb/usr/lib/python3/dist-packages
	cp -r tmp/kosmorrolib-$(KOSMORROLIB_VERSION).dist-info kosmorrolib-deb/usr/lib/python3/dist-packages
	cp deb/kosmorrolib/control kosmorrolib-deb/DEBIAN/control

	curl https://raw.githubusercontent.com/Kosmorro/lib/refs/tags/v$(KOSMORROLIB_VERSION)/CHANGELOG.md | python deb/mkchangelogs.py python3-kosmorrolib Deuchnord "jerome@deuchnord.fr" | gzip -9 > kosmorrolib-deb/usr/share/doc/python3-kosmorrolib/changelog.gz
	curl https://raw.githubusercontent.com/Kosmorro/lib/refs/tags/v$(KOSMORROLIB_VERSION)/LICENSE.md > kosmorrolib-deb/usr/share/doc/python3-kosmorrolib/copyright


	sed -i "s/Version: __VERSION__/Version: $(KOSMORROLIB_VERSION)/" kosmorrolib-deb/DEBIAN/control

	fakeroot dpkg-deb --build kosmorrolib-deb
	mv kosmorrolib-deb.deb python3-kosmorrolib_$(KOSMORROLIB_VERSION)_all.deb

	rm -rf kosmorrolib-deb tmp


kosmorro.deb:
	mkdir -p kosmorro-deb/DEBIAN
	mkdir -p kosmorro-deb/usr/bin
	mkdir -p kosmorro-deb/usr/share/doc/kosmorro
	mkdir -p kosmorro-deb/usr/share/man/man1
	mkdir -p kosmorro-deb/usr/lib/python3/dist-packages

	pip install --target=tmp kosmorro
	# remove pycache folders:
	rm -rf tmp/kosmorro/__pycache__ tmp/kosmorro/i18n/__pycache__
	# Replace shebang in executable:
	echo -e "#!/usr/bin/env python3\n$$(tail -n +2 tmp/bin/kosmorro)" > tmp/bin/kosmorro

	cp -r tmp/kosmorro kosmorro-deb/usr/lib/python3/dist-packages
	cp -r tmp/kosmorro-$(KOSMORRO_VERSION).dist-info kosmorro-deb/usr/lib/python3/dist-packages
	cp tmp/bin/kosmorro kosmorro-deb/usr/bin/kosmorro

	curl https://raw.githubusercontent.com/Kosmorro/kosmorro/refs/tags/v$(KOSMORRO_VERSION)/manpage/kosmorro.1.md | ronn --roff | gzip -9 > kosmorro-deb/usr/share/man/man1/kosmorro.1.gz
	curl https://raw.githubusercontent.com/Kosmorro/kosmorro/refs/tags/v$(KOSMORRO_VERSION)/CHANGELOG.md | python deb/mkchangelogs.py python3-kosmorro Deuchnord "jerome@deuchnord.fr" | gzip -9 > kosmorro-deb/usr/share/doc/kosmorro/changelog.gz
	curl https://raw.githubusercontent.com/Kosmorro/kosmorro/refs/tags/v$(KOSMORRO_VERSION)/LICENSE.md > kosmorro-deb/usr/share/doc/kosmorro/copyright

	cp deb/kosmorro/control kosmorro-deb/DEBIAN/control

	chmod +x kosmorro-deb/usr/bin/kosmorro
	sed -i 's/#!\/usr\/bin\/python/#!\/usr\/bin\/python3/' kosmorro-deb/usr/bin/kosmorro

	sed -i "s/Version: __VERSION__/Version: $(KOSMORRO_VERSION)/" kosmorro-deb/DEBIAN/control

	fakeroot dpkg-deb --build kosmorro-deb
	mv kosmorro-deb.deb kosmorro_$(KOSMORRO_VERSION)_all.deb

	rm -rf kosmorro-deb tmp
