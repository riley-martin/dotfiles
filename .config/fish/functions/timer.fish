function timer --description 'A simple command line timer'
    for i in (seq 0 $argv[1])
        printf '\r'
        printf $i
        sleep 1
    end
    printf '\n'
end
