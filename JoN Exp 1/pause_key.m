[kd, kp] = cgkeymap; % check for responses

if sum(kp) ~= 0 % evaluate responses

    kp = find(kp);
    kp = kp(1); 

    if kp == keys(5) % pause

        kp = 0;

        while kp ~= keys(5) % continue
            [kd, kp] = cgkeymap;

            if sum(kp) ~= 0 
                kp = find(kp);
                kp = kp(1);
            end
        end

    end

end