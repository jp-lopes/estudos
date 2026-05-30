from pyscipopt import Model

# 1. Inicializar o modelo
modelo_scip = Model("Ex5_3")

# Ocultar o log de processamento no terminal (opcional para manter o output limpo)
modelo_scip.hideOutput(True)

i = 0
m = int(input())
a = [[0 for _ in range(3)] for _ in range(m)]

#print(a)

for i in range(m):
    a[i][0], a[i][1], a[i][2] = input().split(" ")

# 2. Instanciar Variáveis
# vtype="I" para Inteiras, "C" para Contínuas, "B" para Binárias.
x1_scip = modelo_scip.addVar(vtype="C", name="x1", lb=0)
x2_scip = modelo_scip.addVar(vtype="C", name="x2", lb=0)
x3_scip = modelo_scip.addVar(vtype="I", name="x3", lb=0)

# 3. Definir a Função Objetivo e o sentido (maximize/minimize)
modelo_scip.setObjective(1 * x1_scip - 0.99 * x2_scip + 1.01 * x3_scip, sense="maximize")

# 4. Montar as Restrições (usamos addCons no SCIP)
for i in range(m):
    modelo_scip.addCons(a[i][0] * x1_scip + a[i][1] * x2_scip + a[i][2] * x3_scip <= 0, name=f"Restricao_{i}")

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