from pyscipopt import Model

# 1. Inicializar o modelo
modelo_scip = Model("Ex5_2")

# Ocultar o log de processamento no terminal (opcional para manter o output limpo)
modelo_scip.hideOutput(True)

a = input().split(" ")
a11 = float(a[0])
a12 = float(a[1])
a13 = float(a[2])
a = input().split(" ")
a21 = float(a[0])
a22 = float(a[1])
a23 = float(a[2])

# 2. Instanciar Variáveis
# vtype="I" para Inteiras, "C" para Contínuas, "B" para Binárias.
x1_scip = modelo_scip.addVar(vtype="C", name="x1", lb=0)
x2_scip = modelo_scip.addVar(vtype="C", name="x2", lb=0)
x3_scip = modelo_scip.addVar(vtype="I", name="x3", lb=0)

# 3. Definir a Função Objetivo e o sentido (maximize/minimize)
modelo_scip.setObjective(1 * x1_scip - 0.99 * x2_scip + 1.01 * x3_scip, sense="maximize")

# 4. Montar as Restrições (usamos addCons no SCIP)
modelo_scip.addCons(a11 * x1_scip + a12 * x2_scip + a13 * x3_scip <= 8, name="Restricao_1")
modelo_scip.addCons(a21 * x1_scip + a22 * x2_scip + a23 * x3_scip >= 1, name="Restricao_2")

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