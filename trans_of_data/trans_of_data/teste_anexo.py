import requests
import pdfplumber
import pandas as pd
import os
import zipfile

def baixar_pdf(url, pdf_path):
    
    
    # downloads the PDF from the given URL
    try:
        response = requests.get(url)
        response.raise_for_status()  # raises exception for HTTP error
        with open(pdf_path, "wb") as f:
            f.write(response.content)
        return True
    except requests.exceptions.RequestException as e:
        print(f"Erro ao baixar o PDF: {e}")
        return False

def extrair_tabelas_pdf(pdf_path):
    
    #extracts tables from the PDF 
    data = []
    try:
        with pdfplumber.open(pdf_path) as pdf:
            for page in pdf.pages:
                tables = page.extract_tables()
                for table in tables:
                    for row in table:
                        if row and any(row):  #avoids empty rows
                            data.append(row)
        return data
    except Exception as e:
        print(f"Erro ao extrair tabelas: {e}")
        return None

def processar_dados(data, substituicoes):
    
    
    #converts data into a DataFrame and replaces abbreviations 
    if not data:
        return None
    df = pd.DataFrame(data)
    if not df.empty:
        df.columns = df.iloc[0]  # Define cabeçalho
        df = df[1:]  # Remove linha do cabeçalho
        df.replace(substituicoes, inplace=True)
    return df

def salvar_csv(df, csv_path):
    
    
    #saves the DataFrame as a CSV file
    if df is not None:
        try:
            df.to_csv(csv_path, index=False, encoding="utf-8")
            return True
        except Exception as e:
            print(f"Erro ao salvar CSV: {e}")
            return False
    return False

def criar_zip(csv_path, zip_filename):
    
    
    #compresses the CSV file into a ZIP archive
    try:
        with zipfile.ZipFile(zip_filename, "w") as zipf:
            zipf.write(csv_path, os.path.basename(csv_path))
        return True
    except Exception as e:
        print(f"Erro ao criar ZIP: {e}")
        return False

def main():
    
    # main function
    seu_nome = "Daniela_LR"
    zip_filename = f"Teste_{seu_nome}.zip"
    url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos/Anexo_I_Rol_2021RN_465.2021_RN627L.2024.pdf"
    pdf_path = "Anexo_I_Rol_2021.pdf"
    csv_path = "rol_procedimentos.csv"
    substituicoes = {"AMB": "Atendimento Ambulatorial", "OD": "Procedimentos Odontológicos"}

    if baixar_pdf(url, pdf_path):
        data = extrair_tabelas_pdf(pdf_path)
        df = processar_dados(data, substituicoes)
        if salvar_csv(df, csv_path):
            if criar_zip(csv_path, zip_filename):
                print(f"Arquivo ZIP criado: {zip_filename}")
                os.remove(pdf_path)
                os.remove(csv_path)

if __name__ == "__main__":
    main()