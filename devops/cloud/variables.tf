variable "project_id" {
  description = "ID del progetto GCP (es. its-ict-sage-csp26)."
  type        = string
}

variable "region" {
  description = "Regione GCP per Cloud Run, Artifact Registry, bucket, Firestore e BigQuery."
  type        = string
  default     = "europe-west6"
}

variable "resource_prefix" {
  description = "Vuoto = progetto dedicato (nomi fissi). Valorizzato (its-ict-sage-<nome>-<cognome>) = progetto condiviso, ogni risorsa parte dal prefisso."
  type        = string
  default     = ""
}

variable "embedding_dimension" {
  description = "Dimensione del vettore 'embedding' in Firestore. Deve coincidere con il modello usato in embeddings.py."
  type        = number
  default     = 768
}

variable "placeholder_image" {
  description = "Immagine pubblica usata alla creazione del servizio Cloud Run. Quella reale la pubblica deploy.yml."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}
