from datetime import datetime
from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",          
        password="senha",    
        database="academia_db" 
    )

@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    busca_aluno = request.args.get('busca_aluno', '').strip()
    busca_personal = request.args.get('busca_personal', '').strip()
    
    aba_ativa = 'consultas' if (busca_aluno or busca_personal) else request.args.get('tab', 'cadastro_aluno')

    # CONSULTA ALUNO
    query_alunos = """
        SELECT 
            A.Matricula, 
            A.Nome, 
            A.CPF, 
            A.Telefone, 
            PL.Nome_Plano, 
            PE.Nome AS Nome_Personal,
            T.Objetivo AS Objetivo_Treino
        FROM ALUNO A
        LEFT JOIN PLANOS PL ON A.ID_Plano = PL.ID_Plano
        LEFT JOIN PERSONAL PE ON A.CREF_Personal = PE.CREF
        LEFT JOIN ALUNO_TREINO AT ON A.Matricula = AT.Matricula
        LEFT JOIN TREINO T ON AT.ID_Treino = T.ID_Treino
    """
    if busca_aluno:
        query_alunos += " WHERE A.Nome LIKE %s"
        cursor.execute(query_alunos, (f"%{busca_aluno}%",))
    else:
        cursor.execute(query_alunos)
    alunos = cursor.fetchall()

    # CONSULTA PERSONAL
    query_personais = "SELECT CREF, Nome, Telefone, Especialidade FROM PERSONAL"
    if busca_personal:
        query_personais += " WHERE Nome LIKE %s"
        cursor.execute(query_personais, (f"%{busca_personal}%",))
    else:
        cursor.execute(query_personais)
    personais = cursor.fetchall()

    # PREENCHER FORMS
    cursor.execute("SELECT ID_Plano, Nome_Plano FROM PLANOS;")
    todos_planos = cursor.fetchall()

    cursor.execute("SELECT CREF, Nome FROM PERSONAL;")
    todos_personais = cursor.fetchall()
    
    cursor.execute("SELECT ID_Treino, Nome, Objetivo FROM TREINO;")
    todos_treinos = cursor.fetchall()
    
    cursor.execute("SELECT Matricula, Nome FROM ALUNO ORDER BY Nome;")
    todos_alunos = cursor.fetchall()
    
    # HISTÓRICO DE ACESSOS
    query_historico_acessos = """
        SELECT 
            AC.ID_Acesso, 
            A.Nome AS Nome_Aluno, 
            DATE_FORMAT(AC.Data_Acesso, '%d/%m/%Y') AS Data_Formatada, 
            AC.Hora_Acesso 
        FROM ACESSO AC
        INNER JOIN ALUNO A ON AC.Matricula = A.Matricula
        ORDER BY AC.Data_Acesso DESC, AC.Hora_Acesso DESC;
    """
    cursor.execute(query_historico_acessos)
    historico_acessos = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template(
        'index.html', 
        alunos=alunos, 
        personais=personais, 
        planos=todos_planos, 
        todos_personais=todos_personais,
        todos_treinos=todos_treinos,
        todos_alunos=todos_alunos,
        historico_acessos=historico_acessos,
        busca_aluno=busca_aluno,
        busca_personal=busca_personal,
        aba_ativa=aba_ativa
    )

@app.route('/inserir_aluno', methods=['POST'])
def inserir_aluno():
    if request.method == 'POST':
        nome = request.form['nome']
        cpf = request.form['cpf']
        telefone = request.form['telefone']
        id_plano = request.form['id_plano']
        cref_personal = request.form['cref_personal']
        treinos_selecionados = request.form.getlist('treinos')
        
        if cref_personal == "":
            cref_personal = None

        conn = get_db_connection()
        cursor = conn.cursor()
        
        try:
            comando_sql = """
                INSERT INTO ALUNO (Nome, CPF, Telefone, ID_Plano, CREF_Personal) 
                VALUES (%s, %s, %s, %s, %s)
            """
            cursor.execute(comando_sql, (nome, cpf, telefone, id_plano, cref_personal))
            nova_matricula = cursor.lastrowid
            
            if treinos_selecionados:
                comando_treino = """
                    INSERT INTO ALUNO_TREINO (Matricula, ID_Treino) 
                    VALUES (%s, %s)
                """
                dados_treinos = [(nova_matricula, int(id_t)) for id_t in treinos_selecionados]
                cursor.executemany(comando_treino, dados_treinos)
            
            conn.commit() 
        except Exception as e:
            conn.rollback()
            print(f"Erro ao salvar aluno: {e}")
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('index', tab='cadastro_aluno'))

@app.route('/inserir_acesso', methods=['POST'])
def inserir_acesso():
    if request.method == 'POST':
        matricula = request.form['matricula']
        
        agora = datetime.now()
        data_acesso = agora.strftime('%Y-%m-%d')
        hora_acesso = agora.strftime('%H:%M:%S')

        conn = get_db_connection()
        cursor = conn.cursor()
        
        comando_sql = """
            INSERT INTO ACESSO (Data_Acesso, Hora_Acesso, Matricula) 
            VALUES (%s, %s, %s)
        """
        cursor.execute(comando_sql, (data_acesso, hora_acesso, matricula))
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return redirect(url_for('index', tab='cadastro_acesso'))

if __name__ == '__main__':
    app.run(debug=True)