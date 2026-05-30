from pyscipopt import Model

# 1. Inicializar o modelo
modelo_scip = Model("Ex5_1")

# Ocultar o log de processamento no terminal (opcional para manter o output limpo)
modelo_scip.hideOutput(True)

a = input().split(" ")
a1 = float(a[0])
a2 = float(a[1])
a3 = float(a[2])

# 2. Instanciar Variáveis
# vtype="I" para Inteiras, "C" para Contínuas, "B" para Binárias.
x1_scip = modelo_scip.addVar(vtype="C", name="x1", lb=0)
x2_scip = modelo_scip.addVar(vtype="C", name="x2", lb=0)
x3_scip = modelo_scip.addVar(vtype="I", name="x3", lb=0)

# 3. Definir a Função Objetivo e o sentido (maximize/minimize)
modelo_scip.setObjective(1.1 * x1_scip + 1.2 * x2_scip + 1.3 * x3_scip, sense="maximize")

# 4. Montar as Restrições (usamos addCons no SCIP)
modelo_scip.addCons(a1 * x1_scip + a2 * x2_scip + a3 * x3_scip <= 12, name="Restricao_1")
modelo_scip.addCons(x1_scip <= 10, name="Restricao_2")
modelo_scip.addCons(x2_scip <= 10, name="Restricao_3")
modelo_scip.addCons(x3_scip <= 10, name="Restricao_4")

# 5. Resolver o problema
modelo_scip.optimize()

# 6. Analisar os Resultados
if modelo_scip.getStatus() == "optimal":
    # getObjVal() pega o valor da função objetivo
    print(round(modelo_scip.getObjVal(),2))
else:
    print("ILIMITADO")