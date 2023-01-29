import ast

with open("terraform\\output.txt", "r") as f:
    file_content = f.read()
    exec(file_content)

pc = []
quagga = []

for dns in aws_pc_public_dns:
    pc.append("ansible_host=" + dns)

for dns in aws_quagga_public_dns:
    quagga.append("ansible_host=" + dns)

i = 0

with open("ansible/host-dev", "w") as f:
    f.writelines("[pcs]\n")
    for i in range(len(pc)):
        f.writelines("pc"+ str(i) + " " + pc[i] + "\n")
    f.writelines("[routers]\n")
    for i in range(len(quagga)):
        f.writelines("quagga"+ str(i) + " " + quagga[i] + "\n")
