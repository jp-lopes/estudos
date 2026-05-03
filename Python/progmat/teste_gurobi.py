import gurobipy as gp
from gurobipy import GRB

# 1. Inicializar o ambiente e o modelo
modelo_gurobi = gp.Model("Mix_Producao_Gurobi")

# 2. Instanciar Variáveis
# vtype=GRB.INTEGER garante que a resposta não será fracionada. 
# Para contínuas, usaríamos GRB.CONTINUOUS e para binárias GRB.BINARY
x = modelo_gurobi.addVar(vtype=GRB.INTEGER, name="Carrinhos_A", lb=0)   # lb: lower bound (limitante inferior) || ub: upper bound (limitante superior) 
y = modelo_gurobi.addVar(vtype=GRB.INTEGER, name="Bonecos_B", lb=0)

# 3. Definir a Função Objetivo
# Queremos maximizar (GRB.MAXIMIZE) a equação de lucro
modelo_gurobi.setObjective(40 * x + 50 * y, GRB.MAXIMIZE)

# 4. Montar as Restrições
modelo_gurobi.addConstr(1 * x + 2 * y <= 40, name="Restricao_Madeira")
modelo_gurobi.addConstr(3 * x + 2 * y <= 60, name="Restricao_MaoDeObra")

# 5. Resolver o problema
modelo_gurobi.optimize()

# 6. Analisar os Resultados
print("\n--- RESULTADOS GUROBI ---")
if modelo_gurobi.status == GRB.OPTIMAL:
    print(f"Status: Solução Ótima Encontrada!")
    print(f"Lucro Máximo (Z): R$ {modelo_gurobi.objVal:.2f}")
    print(f"Produzir Carrinhos (x): {x.X}")
    print(f"Produzir Bonecos (y): {y.X}")
else:
    print("O solver não encontrou uma solução ótima. Verifique o modelo.")