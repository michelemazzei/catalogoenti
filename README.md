
📘 Catalogo Enti

Un'app Flutter per la gestione di un catalogo di prodotti soggetti a manutenzione, con particolare attenzione al contesto militare.

🚀 Obiettivi

* Archiviazione e consultazione di parti di ricambio e revisioni
* Importazione da Excel con Drift e Riverpod
* Interfaccia modulare e scalabile, basata su Material 3

🧱 Tecnologie

* **Flutter** : UI cross-platform
* **Drift** : ORM per SQLite
* **Riverpod** : gestione dello stato
* **Freezed** : modelli immutabili e union types
* **SQLite** : database locale

📂 Struttura (in progress)

* `features/`: moduli verticali per ogni funzionalità
* `core/`: utilità condivise
* `data/`: DAO e repository
* `presentation/`: UI e navigazione

📥 Importazione dati

Supporto per import da file Excel con logging e gestione errori. Ogni parte può avere più revisioni, tracciate e collegate.

🧪 Test

Test unitari su DAO, repository e logica di importazione.

📌 Stato attuale

Progetto in fase iniziale. Struttura modulare e repository pulito già impostati. Prossimo step: modellazione delle revisioni e UI placeholder.
