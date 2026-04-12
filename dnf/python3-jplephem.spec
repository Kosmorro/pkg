Name:           python3-jplephem
Version:        2.24
Release:        2%{?dist}
Summary:        Use a JPL ephemeris to predict planet positions

License:        MIT
URL:            https://github.com/brandon-rhodes/python-jplephem
Source0:        https://files.pythonhosted.org/packages/source/j/jplephem/jplephem-%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch

BuildRequires:  python3-devel
BuildRequires:  python3-pip
BuildRequires:  python3-setuptools
BuildRequires:  python3-wheel

Requires:       python3-numpy

%description
A Python implementation of the math that standard JPL ephemerides use to predict raw (x,y,z) planetary positions.
It is one of the foundations of the Skyfield astronomy library for Python.


%prep
%autosetup -n jplephem-%{version}

%build
%pyproject_wheel

%install
%pyproject_install
%pyproject_save_files jplephem

%files -n python3-jplephem -f %{pyproject_files}
%license LICENSE.txt
%doc README.md

%changelog
* Mon Apr 13 2026 Deuchnord <jerome@deuchnord.fr> - 2.24
- Initial package for Fedora/COPR
