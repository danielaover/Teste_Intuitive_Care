import requests
from bs4 import BeautifulSoup
import os
import zipfile

def web_scraping_ans():
    
    # perform web scraping on the ANS website to download Annexes I and II and compress them
    
    url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"

    try:
        response = requests.get(url)
        response.raise_for_status()  # Lança exceção para status HTTP ruins (4xx ou 5xx)
        soup = BeautifulSoup(response.content, "html.parser")

        # find the links to the PDFs of Annexes I and II
        pdf_links = []
        for link in soup.find_all("a", href=True):
            href = link["href"]
            if "Anexo I" in link.text or "Anexo II" in link.text:
                if href.endswith(".pdf"):
                    if not href.startswith("http"):
                        href = "https://www.gov.br" + href
                    pdf_links.append(href)

        # download the PDFs
        pdf_files = []
        for pdf_link in pdf_links:
            pdf_name = pdf_link.split("/")[-1]
            pdf_path = os.path.join(os.getcwd(), pdf_name)
            pdf_response = requests.get(pdf_link)
            pdf_response.raise_for_status()
            with open(pdf_path, "wb") as f:
                f.write(pdf_response.content)
            pdf_files.append(pdf_path)

        # compress the PDFs into a ZIP file
        zip_filename = "anexos_ans.zip"
        with zipfile.ZipFile(zip_filename, "w") as zip_file:
            for pdf_file in pdf_files:
                zip_file.write(pdf_file, os.path.basename(pdf_file))

        print(f"Anexos baixados e compactados em '{zip_filename}' com sucesso!")

    except requests.exceptions.RequestException as e:
        print(f"Erro ao acessar a URL: {e}")
    except Exception as e:
        print(f"Ocorreu um erro inesperado: {e}")


# calling the scraping function, the main part of the project
if __name__ == "__main__":
    web_scraping_ans()