# Source ~/.zshrc.*
setopt +o nomatch
for script in $(ls "${HOME}/.zshrc."* 2>/dev/null)
do
    case "$script" in
        *.old)
            continue ;;
        *.bak)
            continue ;;
        *)
            echo "Sourcing $script"
            . "$script"
            echo "Finished sourcing $script"
            ;;
    esac
done

