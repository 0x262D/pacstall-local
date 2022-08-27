name="sublimemerge-pill"
pkgname="sublimemerge-pill"
version="2077"

url="https://gist.githubusercontent.com/0x262D/c7419da5d8ba633eb370fbc21247bcac/raw/900020717076540f73ea8efa2233025da9a2553d/nop"
hash="2b8fbda969a8aaa908e763c57e6b22a1697b7c0c5f95fc35b95d492fcc54d082"

# depends="sublime-merge"
pacdeps=("sublimemerge-deb")
build_depends="xxd sudo"
description="Sublime text like Git GUI Client"
maintainer="0x262D <pacstall@copypaste.anonaddy.me>"

file='/opt/sublime_merge/sublime_merge'
chsum='189196010502F17EB99A38D8F64163BA'
pchsum='151be274aa54b64a59a8dffb5187c5dd'

license_file="${HOME}/.config/sublime-merge/Local/License.sublime_license"
dummy_license_md5="e9fd43448dfcc60191ed9e2d0db0d4df"

prepare() {
  # Check is file exists
  if [[ ! -f ${file}   ]]; then
    echo "Sublime merge binary not found!"
    return 1
  fi

  # Make backup for binary file if checksum is ok
    if md5sum -c --quiet <<< "${chsum} ${file}"; then
      echo "Create binary backup file: ${file}.$("${file}" -v | grep -o '[0-9]*$')"
      sudo cp "${file}"{,".$("${file}" -v | grep -o '[0-9]*$')"}
  else
     echo "Incorret binary hash!"
     echo "Expected: ${chsum}  ${file}"
     echo "Current:  $(md5sum "${file}")"
     return 1
  fi
}

build() {
  true
}

install() {
  # Patch binary if checksum is ok
  if md5sum -c --quiet <<< "${chsum} ${file}"; then
    echo "Patch binary: ${file} [${chsum}]"
    echo 003CB652: 48 31 C0 C3          | sudo xxd -r - "${file}"
    echo 003CE75D: 90 90 90 90 90       | sudo xxd -r - "${file}"
    echo 003CE778: 90 90 90 90 90       | sudo xxd -r - "${file}"
    echo 003CCC12: 48 31 C0 48 FF C0 C3 | sudo xxd -r - "${file}"
    echo 003CB39E: C3                   | sudo xxd -r - "${file}"
    echo 003CAFCE: C3                   | sudo xxd -r - "${file}"

    echo "Create NOP file (workaround)"
    sudo install -Dm644 "nop" "${pkgdir}/usr/share/${pkgname}/nop"
  else
     echo "Incorret original binary hash!"
     echo "Expected: ${chsum}  ${file}"
     echo "Current:  $(md5sum "${file}")"
     return 1
  fi

  if md5sum -c --quiet <<< "${pchsum} ${file}"; then
    echo "Original binary succesfuly patched!"
    return 0
  else
    echo "Patched binary Incorret!"
    return 1
  fi
}

postinst() {
  # Add a dummy licence
  if [[ ! -f ${license_file}   ]]; then
    echo "License file not found, create dummy licence ..."
    mkdir -pv "${HOME}/.config/sublime-merge/Local"
    touch "${license_file}"

    {
      echo "----- BEGIN LICENSE -----"
      echo "Your Name"
      echo "Whatever Text"
      echo "0000-000000"
      echo "00000000000000000000000000000000"
      echo "00000000000000000000000000000000"
      echo "00000000000000000000000000000000"
      echo "00000000000000000000000000000000"
      echo "00000000000000000000000000000000"
      echo "00000000000000000000000000000000"
      echo "00000000000000000000000000000000"
      echo "00000000000000000000000000000000"
      echo "----- END LICENSE -----"
      echo ""
    } > "${license_file}"
  else
    echo "License file already exists!"
  fi
  echo "License file: ${license_file}"
  cat "${license_file}"
}

removescript() {
  # Restore backuped binary
  backup_binary="$(echo "${file}".* | grep "${file}")"
  if [[ -f ${backup_binary} && -f ${file} ]]; then
    echo "Backup binary found!"
    echo "Try to move ${backup_binary} -> ${file}"
    sudo rm "${file}"
    sudo mv "${backup_binary}" "${file}"
  fi

  # Remove a dummy licence
  if [[ -f ${license_file}   ]]; then
    if md5sum -c --quiet <<< "${dummy_license_md5} ${license_file}"; then
      echo "Dummy license found!"
      echo "Remove ${license_file}"
      rm "${license_file}"
    fi
  fi
}

# vim:set ft=sh ts=2 sw=2 et:
