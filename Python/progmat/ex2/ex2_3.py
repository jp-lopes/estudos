from pyscipopt import Model

# 1. Inicializar o modelo
modelo_scip = Model("Ex1_1")

# Ocultar o log de processamento no terminal (opcional para manter o output limpo)
modelo_scip.hideOutput(True)

# 2. Instanciar Variáveis
# vtype="I" para Inteiras, "C" para Contínuas, "B" para Binárias.
x1_scip = modelo_scip.addVar(vtype="C", name="x1", lb=0)
x2_scip = modelo_scip.addVar(vtype="I", name="x2", lb=0)

# 3. Definir a Função Objetivo e o sentido (maximize/minimize)
modelo_scip.setObjective(10 * x1_scip + 6 * x2_scip, sense="maximize")

# 4. Montar as Restrições (usamos addCons no SCIP)
modelo_scip.addCons(9 * x1_scip + 5 * x2_scip <= 45, name="Restricao_1")
modelo_scip.addCons(-4 * x1_scip + 5 * x2_scip <= 5, name="Restricao_1")

# 5. Resolver o problema
modelo_scip.optimize()


# 6. Analisar os Resultados
if modelo_scip.getStatus() == "optimal":
    # getObjVal() pega o valor da função objetivo
    print(round(modelo_scip.getObjVal(),2))
    # getVal() pega o valor de uma variável específica
    print(f"{modelo_scip.getVal(x1_scip):.2f}")
    print(f"{modelo_scip.getVal(x2_scip):.1f}")
else:
    print("O solver não encontrou uma solução ótima. Verifique o modelo.")