#!/bin/bash

if [ ! -f "sourceme.sh" ]; then
    echo "Error: sourcme.sh not found"
    exit 1
fi

source sourceme.sh

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

#creates single testpoint in the bat test
function create_bat_testpoint
{
    local input=$1
    local cmd=$2
    local expected_out=$3
    local fname=$4
    local custom_message=$5
    local custom_check=$6
    echo "create_bat_testpoint <$input> <$cmd> <$expected_out> <$fname> <$custom_message> <$custom_check>"
    
    if [ "$custom_message" != "" ]; then
        echo "@test \"$custom_message\" {" >> $fname
    else
        echo "@test \"<$cmd $input> should return <$expected_out>\" {" >> $fname
    fi
    
    echo "  run $cmd $input" >> $fname
    
    if [ "$custom_check " != "" ]; then
        echo "  $custom_check" >> $fname
    else
        echo "  [ \"\$status\" -eq 0 ]" >> $fname
        echo "  [ \"\$output\" = \"$expected_out\" ]" >> $fname
    fi
    echo "}" >> $fname
    echo >> $fname
}

#creating bad tests
function create_bat_testcase_for_command_option_one
{
    current_command="$command_option_one"
    fname=$current_command."bat"
    #use cases
    
    rm $fname -f
    touch $fname
    command="$BIN2TEST $current_command"
    for input in "${!test_vector[@]}"; do
        expected_out=${test_vector[$input]}
        create_bat_testpoint "$input" "$command" "$expected_out" "$fname" "" ""
    done

    #corner cases
    fname="cornercases_$current_command.bat"
    rm $fname -f
    touch $fname
    create_bat_testpoint "-1" "$command" "1" "$fname" ""
    create_bat_testpoint "00" "$command" "2" "$fname" ""
    create_bat_testpoint "" "$command" "3" "$fname" ""
    create_bat_testpoint "abc" "$command" "4" "$fname" ""
}


#creating bad tests
function create_bat_testcase_for_command_option_two
{
    
    current_command="$command_option_two"
    fname=$current_command."bat"

    rm $fname -f
    touch $fname
    command="$BIN2TEST $current_command"
    for input in "${!test_vector[@]}"; do
        cust_msg="<$command $input $input.f> should write <$input> to <$input.f> file"
        cust_check="[ \"\`cat $input.f\`\" = \"$expected_out\" ]"
        expected_out=${test_vector[$input]}
        create_bat_testpoint "$input $input.f" "$command" "$expected_out" "$fname" "$cust_msg" "$cust_check"
    done

    #corner cases
    #fname="cornercases_$current_command.bat"
    #rm $fname -f
    #touch $fname
    #create_bat_testpoint "-1" "$command" "1" "$fname" ""
    #create_bat_testpoint "00" "$command" "2" "$fname" ""
    #create_bat_testpoint "" "$command" "3" "$fname" ""
    #create_bat_testpoint "abc" "$command" "4" "$fname" ""
}


function create_bat_testcase_for_command_option_three
{
    
    current_command="$command_option_three"
    fname=$current_command."bat"

    rm $fname -f
    touch $fname
    command="$BIN2TEST $current_command"
    for input in "${!test_vector[@]}"; do
        #cust_check="[ \"\`cat $input.f\`\" = \"$expected_out\" ]"
        expected_out=${test_vector[$input]}
        cust_msg="<$command $input.f> should return <$expected_out> when reading <$input.f> file"
        create_bat_testpoint "$input.f" "$command" "$expected_out" "$fname" "$cust_msg" 
    done

    #corner cases
    #fname="cornercases_$current_command.bat"
    #rm $fname -f
    #touch $fname
    #create_bat_testpoint "-1" "$command" "1" "$fname" ""
    #create_bat_testpoint "00" "$command" "2" "$fname" ""
    #create_bat_testpoint "" "$command" "3" "$fname" ""
    #create_bat_testpoint "abc" "$command" "4" "$fname" ""
}


function genereate_test_cases
{
    declare -a test_vector
    test_vector[0]=$type_d
    test_vector[3]=$type_a
    test_vector[4]=$type_b
    #test_vector[5]=$type_d
    test_vector[7]=$type_d
    test_vector[8]=$type_b
    test_vector[9]=$type_a
    test_vector[12]=$type_c
    test_vector[24]=$type_c
    test_vector[33]=$type_c
    test_vector[36]=$type_c
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

main

#current_command="$command_option_two"
#fname=$current_command."bat"
#rm $fname -f
#touch $fname
#command="$BIN2TEST $current_command"
#for input in "${!test_vector[@]}"; do
#    expected_out=${test_vector[$input]}
#    file="$input.f"
#    cmd="$command $input $file"
#    echo "@test \"<$cmd> should save write <$expected_out> to $file\" {" >> $fname
#    echo "  run $cmd" >> $fname
#    echo "  res=\`cat $file\`" >> $fname
#    echo "  [ \"\$status\" -eq 0 ]" >> $fname
#    echo "  [ \"\$res\" = \"$expected_out\" ]" >> $fname
#    echo "}" >> $fname
#    echo >> $fname
#done



