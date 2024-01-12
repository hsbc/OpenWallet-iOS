export PATH="$PATH:/Users/$USER/.brew/bin"
if which swiftlint > /dev/null; then
    swiftlint --fix && swiftlint
else
    echo "warning: SwiftLint not installed."
    exit 1
fi