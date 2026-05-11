try:
    attack_count = 0
    with open("auth_audit.log", "r") as log_file:
        with open("brute_report.txt", "w") as report:
            for line in log_file:
                if "Failed password" in line:
                    report.write(line)
                    attack_count += 1  # Add 1 to the tally
    print(f"[*] Audit Complete. Extracted {attack_count} threat signatures to brute_report.txt")

except FileNotFoundError:
    print("[-] Error: The evidence file 'auth_audit.log' is missing.")
    
