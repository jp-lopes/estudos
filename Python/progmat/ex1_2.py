from pyscipopt import Model

# 1. Inicializar o modelo
modelo_scip = Model("Ex1_1")

# Ocultar o log de processamento no terminal (opcional para manter o output limpo)
modelo_scip.hideOutput(True)

# 2. Instanciar Variáveis
# vtype="I" para Inteiras, "C" para Contínuas, "B" para Binárias.
x1_scip = modelo_scip.addVar(vtype="C", name="x1", lb=0)
x2_scip = modelo_scip.addVar(vtype="C", name="x2", lb=0)
x3_scip = modelo_scip.addVar(vtype="C", name="x3", lb=0)

# 3. Definir a Função Objetivo e o sentido (maximize/minimize)
modelo_scip.setObjective(0.56 * x1_scip + 0.81 * x2_scip + 0.46 * x3_scip, sense="minimize")

# 4. Montar as Restrições (usamos addCons no SCIP)
modelo_scip.addCons(0.2 * x1_scip + 0.5 * x2_scip + 0.4 * x3_scip >= 0.3, name="Restricao_1")
modelo_scip.addCons(0.6 * x1_scip + 0.4 * x2_scip + 0.4 * x3_scip >= 0.5, name="Restricao_2")
modelo_scip.addCons(1 * x1_scip + 1 * x2_scip + 1 * x3_scip == 1, name="Restricao_3")


# 5. Resolver o problema
modelo_scip.optimize()


# 6. Analisar os Resultados
if modelo_scip.getStatus() == "optimal":
    # getObjVal() pega o valor da função objetivo
    print(f"{modelo_scip.getObjVal():.1f}")
else:
    print("O solver não encontrou uma solução ótima. Verifique o modelo.")