Name:           python3-skyfield-data
Version:        7.0.0
Release:        2%{?dist}
Summary:        Minimal data files to work with python3-skyfield

License:        MIT
URL:            https://github.com/brunobord/skyfield-data
Source0:        https://files.pythonhosted.org/packages/source/s/skyfield-data/skyfield_data-%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch

BuildRequires:  python3-devel
BuildRequires:  python3-pip
BuildRequires:  python3-setuptools
BuildRequires:  python3-wheel

%description
Skyfield is a Python library for astronomical computations.
It depends on various data files to accurately compute moon phases, planet
positions, etc.
Several issues are raised by these data files:
- If they're not found in the path of the Loader, they're downloaded at
runtime. Depending on the archive you're requesting, some files might be
very large, causing a long delay (directly related to your network
bandwidth). In the case of a web server app, you'd cause a timeout on
client's end.
- They come mainly from 2 sources: NASA's JPL, and the IERS. If one of them
is temporarily unavailable, you couldn't perform any computation.
- In some countries, or behind some filtering proxies, some hosts may be
blocked.
- These files have an expiration date (in a more or less distant future). As
a consequence, even if the files are already downloaded in the right path,
at each runtime you could possibly have to download one or more files
before making any computation using them.


%prep
%autosetup -n skyfield_data-%{version}

%build
%pyproject_wheel

%install
%pyproject_install
%pyproject_save_files skyfield_data

%files -n python3-skyfield-data -f %{pyproject_files}
%license COPYING
%doc README.md

%changelog
* Mon Apr 13 2026 Deuchnord <jerome@deuchnord.fr> - 7.0.0
- Initial package for Fedora/COPR
