#!/bin/bash

# define test selectors
test_selectors=(
    "model_does_not_exist"
    "model_a1"
    "model_a1+"
    "model_b"
    "+model_b"
    "model_b+"
    "+model_b+"
    "+model_c1"
    "tag:tag_a1_b"
    "tag:tag_a2_c1_c2,+c2"
    "model_a2 model_c1"
    "a1_b"
    "a1_b.model_a1"
    "path:models/a1_b"
)

# Initialize variables for each flag
verbose=0
quiet=0

# Loop through all provided arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)
            verbose=1  # Set verbose flag
            shift      # Move to the next argument
            ;;
        -q|--quiet)
            quiet=1    # Set quiet flag
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done


if ! command -v dbt &> /dev/null; then
    printf "\e[31mFAILED\e[0m: dbt is not installed or not in PATH."
    exit 1
fi

# flag for final result
diff_cnt=0

echo "##################################################"
echo "###   Running tests for get_refs_recursive()   ###"
echo "##################################################"
# compare results from macro to CLI ls command for each selector
for item in "${test_selectors[@]}"; do
    echo -n "Testing selector '$item'… "
    dbt -q ls -s "$item" | cut -d '.' -f 3 > cli.log
    dbt -q run-operation dbt_diving.get_refs_recursive --args "{\"select\": \"$item\", \"print_list\": True}" > macro.log

    if diff cli.log macro.log > /dev/null; then
        printf "\e[32mPASSED\e[0m\n"
        if [ "$verbose" -eq 1 ]; then
            echo "'dbt ls' command returned:" | sed 's/^/  /'
            cat cli.log | sed 's/^/    /'
            echo "'get_refs_recursive()' returned:" | sed 's/^/  /'
            cat macro.log | sed 's/^/    /'
        fi
    else
        printf "\e[31mFAILED\e[0m\n"
        if [ "$quiet" -eq 0 ]; then
            echo "'dbt ls' command returned:" | sed 's/^/  /'
            cat cli.log | sed 's/^/    /'
            echo "'get_refs_recursive()' returned:" | sed 's/^/  /'
            cat macro.log | sed 's/^/    /'
        fi
        ((diff_cnt++))
    fi
done

rm cli.log macro.log

# print result and exit script
if [ "$diff_cnt" -eq 0 ]; then
    echo -n "All test cases "
    printf "\e[32mPASSED\e[0m\n"
else
    echo -n "$diff_cnt test case(s) "
    printf "\e[31mFAILED\e[0m\n"
fi
exit $diff_cnt
