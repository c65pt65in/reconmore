#!/usr/bin/env python3

import subprocess
import modes.modules.emails
import modes.modules.documents

def advanced_func(input_domain,filename):
    subprocess.run(['/usr/share/reconmore/modes/modules/module_1.sh', input_domain, filename])
    subprocess.run(['/usr/share/reconmore/modes/modules/module_2.sh', input_domain, filename])        
    subprocess.run(['/usr/share/reconmore/modes/modules/module_3.sh', input_domain, filename])
    subprocess.run(['/usr/share/reconmore/modes/modules/module_4.sh', input_domain, filename])
    subprocess.run(['/usr/share/reconmore/modes/modules/module_5.sh', input_domain, filename])
    subprocess.run(['/usr/share/reconmore/modes/modules/module_7.sh', input_domain, filename])
    subprocess.run(['/usr/share/reconmore/modes/modules/module_9.sh', input_domain, filename])
