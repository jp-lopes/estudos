from pyscipopt import Model, quicksum

# 1. Inicializar o modelo
modelo_scip = Model("Ex6_1")

# Ocultar o log de processamento no terminal (opcional para manter o output limpo)
modelo_scip.hideOutput(True)

i = 0
n = int(input())
m = int(input())

tipos = input()
tipos = tipos.replace('R', 'C')
tipos = tipos.replace('Z', 'I')
tipos = tipos.split()
#print(tipos)

a = [[0 for _ in range(n)] for _ in range(m)]

#print(a)

for j in range(m):
    linha_m = input().split(" ")
    for i in range(n):
        a[j][i] = linha_m[i]

# 2. Instanciar Variáveis
# vtype="I" para Inteiras, "C" para Contínuas, "B" para Binárias.
x = [0]*n
for i in range(n):
    x[i] = modelo_scip.addVar(vtype=tipos[i], name=f"x{i}", lb=0)

# 3. Definir a Função Objetivo e o sentido (maximize/minimize)
modelo_scip.setObjective(quicksum(x[i] for i in range(n)), sense="maximize")

# 4. Montar as Restrições (usamos addCons no SCIP)
for j in range(m):
    modelo_scip.addCons(quicksum(a[j][i] * x[i] for i in range(n)) <= 10)

# 5. Resolver o problema
modelo_scip.optimize()

status = modelo_scip.getStatus()
# 6. Analisar os Resultados
if status == "optimal":
    # getObjVal() pega o valor da função objetivo
    print(round(modelo_scip.getObjVal(),2))
elif status == "infeasible":
    print("INFACTÍVEL")
elif status == "unbounded":
    print("ILIMITADO")