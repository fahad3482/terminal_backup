#!/bin/bash

# Simple Bash Calculator

echo "Simple Calculator"
echo "-----------------"
echo "Enter first number: "
read num1

echo "Enter operator (+, -, *, /): "
read op

echo "Enter second number: "
read num2

case $op in
    +) result=$(echo "$num1 + $num2" | bc);;
    -) result=$(echo "$num1 - $num2" | bc);;
    \*) result=$(echo "$num1 * $num2" | bc);;
    /) 
        if [ "$num2" == "0" ]; then
            echo "Error: Division by zero!"
            exit 1
        fi
        result=$(echo "scale=2; $num1 / $num2" | bc)
        ;;
    *)
        echo "Invalid operator!"
        exit 1
        ;;
esac

echo "Result: $result"
