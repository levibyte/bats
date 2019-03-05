#!/bin/bash

#creates single testpoint in the bat test
function create_bat_testpoint
{
    local input=$1
    local cmd=$2
    local expected_out=$3
    local test_file=$4
    local custom_message=$5
    local custom_check=$6
    echo "create_bat_testpoint <$input> <$cmd> <$expected_out> <$test_file> <$custom_message> <$custom_check>"
    
    if [ "$custom_message" != "" ]; then
        if [ "$custom_message" == "negative_case" ]; then
            custom_message="<$command $input> should not be successfull"
            custom_check="[ \"\$status\" -ne 0 ]"
        fi
        echo "@test \"$custom_message\" {" >> $test_file
    else
        echo "@test \"<$cmd $input> should return <$expected_out>\" {" >> $test_file
    fi
    
    echo "  run $cmd $input" >> $test_file
    
    if [ "$custom_check" != "" ]; then
        echo "  $custom_check" >> $test_file
    else
        echo "  [ \"\$status\" -eq 0 ]" >> $test_file
        echo "  [ \"\$output\" = \"$expected_out\" ]" >> $test_file
    fi
    
    echo "}" >> $test_file
    echo >> $test_file
}

#creating bad tests
function create_bat_testcase_for_command_option_one
{
    local current_command="$command_option_one"
    local test_file=$current_command."bat"
    #use cases
    
    rm $test_file -f
    touch $test_file
    command="$BIN2TEST $current_command"
    for input in "${!test_vector[@]}"; do
        expected_out=${test_vector[$input]}
        create_bat_testpoint "$input" "$command" "$expected_out" "$test_file" "" ""
    done

    #corner cases
    test_file="cornercases_$current_command.bat"
    rm $test_file -f
    touch $test_file
    create_bat_testpoint "-1" "$command" "" "$test_file" "negative_case" "-"
    create_bat_testpoint "00" "$command" "" "$test_file" "negative_case" "-"
    #create_bat_testpoint " "  "$command" "" "$test_file" "negative_case" "-"
    create_bat_testpoint "abc" "$command" "" "$test_file" "negative_case" "-"
}


#creating bad tests
function create_bat_testcase_for_command_option_two
{
    
    local current_command="$command_option_two"
    local test_file=$current_command."bat"

    rm $test_file -f
    touch $test_file
    command="$BIN2TEST $current_command"
    for input in "${!test_vector[@]}"; do
        expected_out=$input
        cust_msg="<$command $input $input.f> should write <$input> to <$input.f> file"
        cust_check="[ \"\`cat $input.f\`\" = \"$expected_out\" ]"
        create_bat_testpoint "$input $input.f" "$command" "$expected_out" "$test_file" "$cust_msg" "$cust_check"
    done

    #corner cases
    test_file="cornercases_$current_command.bat"
    rm $test_file -f
    touch $test_file
    num=3
    
    echo "mkdir -p  dir" >> $test_file
    echo "mkdir -p  not_exisiting_dir" >> $test_file
    echo "touch not_writable_file" >> $test_file
    echo "chmod 555 not_writable_file" >> $test_file
    echo "mkdir -p  dir" >> $test_file
    echo "mkdir -p  not_writable_dir" >> $test_file
    echo "chmod 555 not_writable_dir" >> $test_file
    echo >> $test_file
        
    
    #mkdir -p  dir
    input=dir/f
    cust_msg="<$command $num $input.f> should write <$num> to <$input> file"
    cust_check="[ \"\`cat $input\`\" = \"$expected_out\" ]"
    create_bat_testpoint "$num $input" "$command" "$expected_out" "$test_file" "$cust_msg" "$cust_check"

    #mkdir -p  not_exisiting_dir
    file=not_exisiting_dir/f
    create_bat_testpoint "$num $file" "$command" "" "$test_file" "negative_case" "-"

    #touch not_writable_file
    #chmod 555 not_writable_file
    file=not_writable_file
    create_bat_testpoint "$num $file" "$command" "" "$test_file" "negative_case" "-"


    #mkdir -p  not_writable_dir
    #chmod 555 not_writable_dir
    file=not_writable_dir/file
    create_bat_testpoint "$num $file" "$command" "" "$test_file" "negative_case" "-"

    
    file=test.file
    create_bat_testpoint "-1 $file" "$command" "" "$test_file" "negative_case" "-"
    create_bat_testpoint "00 $file" "$command" "" "$test_file" "negative_case" "-"
    create_bat_testpoint "" "$command" "" "$test_file" "negative_case" "-"
    create_bat_testpoint "abc $file" "$command" "" "$test_file" "negative_case" "-"
    
}


function create_bat_testcase_for_command_option_three
{
    
    local current_command="$command_option_three"
    local test_file=$current_command."bat"

    rm $test_file -f
    touch $test_file
    command="$BIN2TEST $current_command"
    for input in "${!test_vector[@]}"; do
        expected_out=${test_vector[$input]}
        cust_msg="<$command $input.f> should return <$expected_out> when reading <$input.f> file"
        create_bat_testpoint "$input.f" "$command" "$expected_out" "$test_file" "$cust_msg" 
    done

    #corner cases
    
    #mkdir -p  not_exisiting_dir
    file=not_exisiting_dir/f
    create_bat_testpoint "$num $file" "$command" "" "$test_file" "negative_case" "-"

    #touch not_writable_file
    #chmod 555 not_writable_file
    file=not_writable_file
    create_bat_testpoint "$num $file" "$command" "" "$test_file" "negative_case" "-"


    #mkdir -p  not_writable_dir
    #chmod 555 not_writable_dir
    file=not_writable_dir/file
    create_bat_testpoint "$num $file" "$command" "" "$test_file" "negative_case" "-"    
}


function genereate_test_cases
{
    declare -a test_vector
    test_vector[0]=$type_d
    test_vector[1]=$type_d
    test_vector[3]=$type_a
    test_vector[4]=$type_b
    test_vector[12]=$type_c
    test_vector[24]=$type_c
    test_vector[33]=$type_a
    test_vector[36]=$type_c
    test_vector[40]=$type_b
    test_vector[41]=$type_d
    test_vector[333]=$type_c
    test_vector[240]=$type_c
    
    #create_test_case_for_command_default
    create_bat_testcase_for_command_option_one
    create_bat_testcase_for_command_option_two
    create_bat_testcase_for_command_option_three
}

function main {
    genereate_test_cases
}


function validate {
    if [ ! -f "sourceme.sh" ]; then
        echo "Error: sourcme.sh not found"
        exit 1
    fi
}


validate

source sourceme.sh

#This is just hack for "obfuscation" reasons
BIN2TEST=$BIN
type_a=$RET_A
type_b=$RET_B
type_c=$RET_C
type_d=$RET_D
type_e=$RET_E

command_option_default=$CMD_DEFAULT
command_option_one=$CMD_ONE
command_option_two=$CMD_TWO
command_option_three=$CMD_THREE
command_option_four=$CMD_FOUR

main




