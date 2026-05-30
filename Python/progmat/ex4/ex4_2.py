from pyscipopt import Model

# 1. Inicializar o modelo
modelo_scip = Model("Ex4_2")

# Ocultar o log de processamento no terminal (opcional para manter o output limpo)
modelo_scip.hideOutput(True)

b = float(input())

# 2. Instanciar Variáveis
# vtype="I" para Inteiras, "C" para Contínuas, "B" para Binárias.
x1_scip = modelo_scip.addVar(vtype="C", name="x1", lb=0)
x2_scip = modelo_scip.addVar(vtype="I", name="x2", lb=0)

# 3. Definir a Função Objetivo e o sentido (maximize/minimize)
modelo_scip.setObjective(x1_scip + 2* x2_scip, sense="maximize")

# 4. Montar as Restrições (usamos addCons no SCIP)
modelo_scip.addCons(x1_scip + x2_scip <= 15, name="Restricao_1")
modelo_scip.addCons(x1_scip <= 10, name="Restricao_2")
modelo_scip.addCons(x2_scip <= b, name="Restricao_3")


# 5. Resolver o problema
modelo_scip.optimize()


# 6. Analisar os Resultados
if modelo_scip.getStatus() == "optimal":
    # getObjVal() pega o valor da função objetivo
    print(round(modelo_scip.getObjVal(),2))
    # getVal() pega o valor de uma variável específica
    print(round(modelo_scip.getVal(x1_scip),2))
    print(round(modelo_scip.getVal(x2_scip),2))
else:
    print("INFACTÍVEL")