Name:           python3-kosmorrolib
Version:        1.0.13
Release:        1%{?dist}
Summary:        Astronomical ephemerides computation library

License:        AGPL-3.0-or-later
URL:            https://kosmorro.space/lib
Source0:        https://files.pythonhosted.org/packages/source/k/kosmorrolib/kosmorrolib-%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch

BuildRequires:  python3-devel
BuildRequires:  python3-pip
BuildRequires:  python3-poetry-core
BuildRequires:  python3-setuptools
BuildRequires:  python3-wheel

Requires:       python3-numpy
Requires:       python3-dateutil
Requires:       python3-skyfield-data

# From @copr/pypi repository:
Requires:       python3-skyfield

%description
Kosmorrolib is a Python library used to compute astronomical ephemerides.
It is based on the Skyfield library and provides simple APIs to compute
positions of celestial objects.

%prep
%autosetup -n kosmorrolib-%{version}

%build
%pyproject_wheel

%install
%pyproject_install
%pyproject_save_files kosmorrolib

%check
# disabled

%files -n python3-kosmorrolib -f %{pyproject_files}
%license LICENSE.md
%doc README.md

%changelog
* Sun Apr 12 2026 Deuchnord <jerome@deuchnord.fr> - 1.0.13-1
- Initial package for Fedora/COPR
