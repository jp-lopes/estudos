from pyscipopt import Model, quicksum

def solve_scheduling():
    # --- Parâmetros do Problema ---
    membros = ["M1", "M2", "M3"]  # Lista de membros
    tarefas = ["T1", "T2", "T3", "T4"]  # Lista de tarefas
    horas_disponiveis = list(range(1, 11))  # Horizonte de tempo (H) [cite: 29]
    
    # Rendimentos [cite: 22]
    # M1 e M2 são veteranos (1.0), M3 é trainee (0.5)
    rendimento = {"M1": 1.0, "M2": 1.0, "M3": 0.5}
    
    # Carga de trabalho necessária para cada tarefa (horas-padrão)
    trabalho_necessario = {"T1": 4, "T2": 2, "T3": 5, "T4": 3}
    
    h_min = 2  # Carga horária mínima por membro [cite: 70]
    h_max = 10 # Carga horária máxima (limite do horizonte)
    
    # Inicializar o Modelo SCIP [cite: 5]
    model = Model("Escalonamento_Academico")
    
    # --- Variáveis de Decisão ---
    # x[i, j, h] = 1 se membro i faz tarefa j na hora h [cite: 31, 35]
    x = {}
    for i in membros:
        for j in tarefas:
            for h in horas_disponiveis:
                x[i, j, h] = model.addVar(vtype="B", name=f"x_{i}_{j}_{h}")
    
    # --- Função Objetivo ---
    # Minimizar o total de horas alocadas (esforço total) [cite: 24, 38]
    model.setObjective(
        quicksum(x[i, j, h] for i in membros for j in tarefas for h in horas_disponiveis),
        "minimize"
    )
    
    # --- Restrições ---
    
    # 1. Conclusão da Tarefa (considerando rendimento) [cite: 39]
    for j in tarefas:
        model.addCons(
            quicksum(x[i, j, h] * rendimento[i] for i in membros for h in horas_disponiveis) >= trabalho_necessario[j],
            name=f"Conclusao_{j}"
        )
    
    # 2. Exclusividade: Um membro faz no máximo uma tarefa por hora [cite: 40]
    for i in membros:
        for h in horas_disponiveis:
            model.addCons(
                quicksum(x[i, j, h] for j in tarefas) <= 1,
                name=f"Exclusividade_{i}_{h}"
            )
            
    # 3. Carga Horária Máxima (h_max)
    for i in membros:
        model.addCons(
            quicksum(x[i, j, h] for j in tarefas for h in horas_disponiveis) <= h_max,
            name=f"CapacidadeMax_{i}"
        )
        
    # 4. Carga Horária Mínima (h_min)
    for i in membros:
        model.addCons(
            quicksum(x[i, j, h] for j in tarefas for h in horas_disponiveis) >= h_min,
            name=f"CargaMinima_{i}"
        )

    # --- Execução e Resultados ---
    model.optimize() 
    
    if model.getStatus() == "optimal":
        print(f"\nStatus: {model.getStatus()}") 
        print(f"Custo Total (Horas): {model.getObjVal()}")
        print(f"Gap de Otimalidade: {model.getGap()}") 
        print(f"Tempo de Processamento: {model.getSolvingTime()}s\n") 
        
        # Exibir Alocação
        for i in membros:
            for h in horas_disponiveis:
                for j in tarefas:
                    if model.getVal(x[i, j, h]) > 0.5:
                        print(f"Hora {h}: {i} alocado na {j}")
    else:
        print("Solução ótima não encontrada.")

if __name__ == "__main__":
    solve_scheduling()