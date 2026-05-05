Name:           kosmorro
Version:        1.0.2
Release:        1%{?dist}
Summary:        Astronomical ephemerides computation program

License:        AGPL-3.0-or-later
URL:            https://kosmorro.space/lib
Source0:        https://files.pythonhosted.org/packages/source/k/kosmorro/kosmorro-%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch

BuildRequires:  make
BuildRequires:  python3-devel
BuildRequires:  python3-pip
BuildRequires:  python3-poetry-core
BuildRequires:  python3-setuptools
BuildRequires:  python3-wheel

Requires:       python3
Requires:       python3-argcomplete
Requires:       python3-babel
Requires:       python3-dateutil
Requires:       python3-kosmorrolib
Requires:       python3-pytz
Requires:       python3-tabulate
Requires:       python3-termcolor

Suggests:       texlive

%description
Kosmorro is a program that calculates your astronomical ephemerides.
It provides the following features:
- Calculate the rise, culmination and set times for any date and any position
on Earth
- Get informed about interesting astronomical events
- Generate a PDF with all the information needed for your observation nights
All calculations are made offline, no Internet connection needed.


%prep
%autosetup -n kosmorro-%{version}

%build
%pyproject_wheel

%install
%pyproject_install
%pyproject_save_files kosmorro

%check
# disabled

%files -n kosmorro -f %{pyproject_files}
/usr/bin/kosmorro
%license LICENSE.md
%doc README.md

%changelog
* Tue May 5 2026 Deuchnord <jerome@deuchnord.fr> - 1.0.2-1
- include the translation files correctly in wheel
- fix pytz dependency that prevents Kosmorro to be installed on some distributions

* Mon Apr 13 2026 Deuchnord <jerome@deuchnord.fr> - 1.0.1-1
- Initial package for Fedora/COPR
