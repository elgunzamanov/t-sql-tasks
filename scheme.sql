CREATE DATABASE PharmacyDrugSalesSystem;
USE PharmacyDrugSalesSystem;

-- NOTE: 1. Rol və İstifadəçi (admin, aptekçi və s.)
CREATE TABLE dbo.roles
(
   id          INT IDENTITY (1,1) PRIMARY KEY,
   name        NVARCHAR(50)  NOT NULL UNIQUE,
   description NVARCHAR(MAX) NULL
);

CREATE TABLE dbo.users
(
   id            INT IDENTITY (1,1) PRIMARY KEY,
   role_id       INT               NOT NULL
      CONSTRAINT fk_users_roles REFERENCES dbo.roles (id),
   username      NVARCHAR(100)     NOT NULL
      CONSTRAINT ux_users_username UNIQUE,
   password_hash NVARCHAR(255)     NOT NULL,
   full_name     NVARCHAR(200)     NULL,
   email         NVARCHAR(200)     NULL,
   phone         NVARCHAR(50)      NULL,
   created_at    DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME(),
   last_login    DATETIMEOFFSET(7) NULL
);

-- NOTE: 2. Suppliers (təchizatçılar)
CREATE TABLE dbo.suppliers
(
   id             INT IDENTITY (1,1) PRIMARY KEY,
   name           NVARCHAR(255) NOT NULL,
   contact_person NVARCHAR(200) NULL,
   phone          NVARCHAR(50)  NULL,
   email          NVARCHAR(200) NULL,
   address        NVARCHAR(MAX) NULL,
   notes          NVARCHAR(MAX) NULL
);

-- NOTE: 3. Kateqoriyalar və Ölçü vahidləri
CREATE TABLE dbo.categories
(
   id          INT IDENTITY (1,1) PRIMARY KEY,
   name        NVARCHAR(150) NOT NULL
      CONSTRAINT ux_categories_name UNIQUE,
   description NVARCHAR(MAX) NULL
);

CREATE TABLE dbo.units
(
   id   INT IDENTITY (1,1) PRIMARY KEY,
   code NVARCHAR(20)  NOT NULL
      CONSTRAINT ux_units_code UNIQUE,
   name NVARCHAR(100) NOT NULL
);

-- NOTE: 4. Dərman məhsulları (SPU səviyyəsi)
CREATE TABLE dbo.drugs
(
   id                    INT IDENTITY (1,1) PRIMARY KEY,
   category_id           INT               NULL
      CONSTRAINT fk_drugs_category REFERENCES dbo.categories (id),
   supplier_id           INT               NULL
      CONSTRAINT fk_drugs_supplier REFERENCES dbo.suppliers (id),
   sku                   NVARCHAR(100)     NULL
      CONSTRAINT ux_drugs_sku UNIQUE,
   name                  NVARCHAR(255)     NOT NULL,
   generic_name          NVARCHAR(255)     NULL,
   manufacturer          NVARCHAR(255)     NULL,
   unit_id               INT               NULL
      CONSTRAINT fk_drugs_unit REFERENCES dbo.units (id),
   barcode               NVARCHAR(100)     NULL
      CONSTRAINT ux_drugs_barcode UNIQUE,
   min_stock             INT               NOT NULL DEFAULT 0,
   prescription_required BIT               NOT NULL DEFAULT 0,
   created_at            DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME(),
   notes                 NVARCHAR(MAX)     NULL
);

-- NOTE: 5. Batch / Lot səviyyəsi (partiya və son istifadə tarixi)
CREATE TABLE dbo.drug_batches
(
   id             INT IDENTITY (1,1) PRIMARY KEY,
   drug_id        INT               NOT NULL
      CONSTRAINT fk_batches_drug REFERENCES dbo.drugs (id) ON DELETE CASCADE,
   batch_number   NVARCHAR(100)     NOT NULL,
   quantity       INT               NOT NULL DEFAULT 0,
   expiry_date    DATE              NULL,
   purchase_price DECIMAL(18, 2)    NOT NULL DEFAULT 0,
   retail_price   DECIMAL(18, 2)    NOT NULL DEFAULT 0,
   created_at     DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME(),
   CONSTRAINT ux_batches_drug_batch UNIQUE (drug_id, batch_number)
);

-- NOTE: 6. Inventar (stok) — məntəqə / bölmə varsa location əlavə edilə bilər
CREATE TABLE dbo.inventory
(
   id            INT IDENTITY (1,1) PRIMARY KEY,
   drug_batch_id INT               NOT NULL
      CONSTRAINT fk_inventory_batch REFERENCES dbo.drug_batches (id) ON DELETE CASCADE,
   location      NVARCHAR(100)     NOT NULL DEFAULT 'main',
   quantity      INT               NOT NULL DEFAULT 0,
   last_updated  DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME()
);

-- NOTE: 7. Qiymət tarixçəsi
CREATE TABLE dbo.price_history
(
   id             INT IDENTITY (1,1) PRIMARY KEY,
   drug_id        INT               NOT NULL
      CONSTRAINT fk_pricehistory_drug REFERENCES dbo.drugs (id) ON DELETE CASCADE,
   effective_from DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME(),
   retail_price   DECIMAL(18, 2)    NOT NULL,
   purchase_price DECIMAL(18, 2)    NULL,
   source         NVARCHAR(100)     NULL
);

-- NOTE: 8. Satınalma (procurement) və əşyalar
CREATE TABLE dbo.purchases
(
   id             INT IDENTITY (1,1) PRIMARY KEY,
   supplier_id    INT               NULL
      CONSTRAINT fk_purchases_supplier REFERENCES dbo.suppliers (id),
   invoice_number NVARCHAR(200)     NULL,
   total_amount   DECIMAL(18, 2)    NOT NULL DEFAULT 0,
   status         NVARCHAR(50)      NOT NULL DEFAULT 'received', -- NOTE: received, pending, cancelled
   created_by     INT               NULL
      CONSTRAINT fk_purchases_user REFERENCES dbo.users (id),
   created_at     DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME(),
   notes          NVARCHAR(MAX)     NULL
);

CREATE TABLE dbo.purchase_items
(
   id INT IDENTITY(1,1) PRIMARY KEY,

   purchase_id INT NOT NULL
      CONSTRAINT fk_purchaseitems_purchase
         REFERENCES dbo.purchases(id)
         ON DELETE CASCADE,

   drug_id INT NOT NULL
      CONSTRAINT fk_purchaseitems_drug
         REFERENCES dbo.drugs(id)
         ON DELETE NO ACTION,

   batch_number NVARCHAR(100) NULL,
   expiry_date DATE NULL,
   unit_price DECIMAL(18,2) NOT NULL,
   quantity INT NOT NULL,

   line_total AS (unit_price * quantity) PERSISTED
);

-- NOTE: 9. Satışlar və satılan əşyalar
CREATE TABLE dbo.customers
(
   id          INT IDENTITY (1,1) PRIMARY KEY,
   full_name   NVARCHAR(255) NOT NULL,
   phone       NVARCHAR(50)  NULL,
   email       NVARCHAR(200) NULL,
   address     NVARCHAR(MAX) NULL,
   national_id NVARCHAR(100) NULL,
   notes       NVARCHAR(MAX) NULL
);

CREATE TABLE dbo.sales
(
   id             INT IDENTITY (1,1) PRIMARY KEY,
   invoice_no     NVARCHAR(100)     NULL
      CONSTRAINT ux_sales_invoice UNIQUE,
   customer_id    INT               NULL
      CONSTRAINT fk_sales_customer REFERENCES dbo.customers (id),
   cashier_id     INT               NULL
      CONSTRAINT fk_sales_user REFERENCES dbo.users (id),
   total_amount   DECIMAL(18, 2)    NOT NULL DEFAULT 0,
   total_discount DECIMAL(18, 2)    NOT NULL DEFAULT 0,
   total_tax      DECIMAL(18, 2)    NOT NULL DEFAULT 0,
   payment_method NVARCHAR(50)      NOT NULL DEFAULT 'cash',     -- NOTE: cash, card, mixed, insurance
   created_at     DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME(),
   status         NVARCHAR(50)      NOT NULL DEFAULT 'completed' -- NOTE: completed, pending, cancelled, returned
);

CREATE TABLE dbo.sale_items
(
   id INT IDENTITY(1,1) PRIMARY KEY,

   sale_id INT NOT NULL
      CONSTRAINT fk_saleitems_sale
         REFERENCES dbo.sales(id)
         ON DELETE CASCADE,

   drug_id INT NOT NULL
      CONSTRAINT fk_saleitems_drug
         REFERENCES dbo.drugs(id)
         ON DELETE NO ACTION,

   drug_batch_id INT NULL
      CONSTRAINT fk_saleitems_batch
         REFERENCES dbo.drug_batches(id),

   quantity INT NOT NULL,
   unit_price DECIMAL(18,2) NOT NULL,
   discount DECIMAL(18,2) NOT NULL DEFAULT 0,
   tax DECIMAL(18,2) NOT NULL DEFAULT 0,

   line_total AS ((unit_price - discount) * quantity + tax) PERSISTED
);

-- NOTE: 10. Reçetələr (prescriptions)
CREATE TABLE dbo.doctors
(
   id             INT IDENTITY (1,1) PRIMARY KEY,
   full_name      NVARCHAR(255) NOT NULL,
   license_no     NVARCHAR(100) NULL,
   phone          NVARCHAR(50)  NULL,
   email          NVARCHAR(200) NULL,
   clinic_address NVARCHAR(MAX) NULL
);

CREATE TABLE dbo.prescriptions
(
   id              INT IDENTITY (1,1) PRIMARY KEY,
   prescription_no NVARCHAR(100) NULL
      CONSTRAINT ux_prescriptions_no UNIQUE,
   patient_id      INT           NULL
      CONSTRAINT fk_prescriptions_patient REFERENCES dbo.customers (id),
   doctor_id       INT           NULL
      CONSTRAINT fk_prescriptions_doctor REFERENCES dbo.doctors (id),
   issued_date     DATE          NOT NULL DEFAULT CONVERT(date, SYSUTCDATETIME()),
   valid_until     DATE          NULL,
   notes           NVARCHAR(MAX) NULL
);

CREATE TABLE dbo.prescription_items
(
   id              INT IDENTITY (1,1) PRIMARY KEY,
   prescription_id INT           NOT NULL
      CONSTRAINT fk_prescriptionitems_prescription REFERENCES dbo.prescriptions (id) ON DELETE CASCADE,
   drug_id         INT           NOT NULL
      CONSTRAINT fk_prescriptionitems_drug REFERENCES dbo.drugs (id),
   dosage          NVARCHAR(200) NULL,
   quantity        INT           NULL,
   instructions    NVARCHAR(MAX) NULL
);

-- NOTE: 11. Ödənişlər və tranzaksiyalar
CREATE TABLE dbo.payments
(
   id        INT IDENTITY (1,1) PRIMARY KEY,
   sale_id   INT               NULL
      CONSTRAINT fk_payments_sale REFERENCES dbo.sales (id),
   amount    DECIMAL(18, 2)    NOT NULL,
   method    NVARCHAR(50)      NOT NULL,
   paid_at   DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME(),
   reference NVARCHAR(200)     NULL
);

-- NOTE: 12. Qayıtma / Geri qaytarılma
CREATE TABLE dbo.returns
(
   id         INT IDENTITY (1,1) PRIMARY KEY,
   sale_id    INT               NULL
      CONSTRAINT fk_returns_sale REFERENCES dbo.sales (id),
   created_by INT               NULL
      CONSTRAINT fk_returns_user REFERENCES dbo.users (id),
   reason     NVARCHAR(MAX)     NULL,
   created_at DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.return_items
(
   id            INT IDENTITY (1,1) PRIMARY KEY,
   return_id     INT            NOT NULL
      CONSTRAINT fk_returnitems_return REFERENCES dbo.returns (id) ON DELETE CASCADE,
   sale_item_id  INT            NULL
      CONSTRAINT fk_returnitems_saleitem REFERENCES dbo.sale_items (id),
   drug_id       INT            NULL
      CONSTRAINT fk_returnitems_drug REFERENCES dbo.drugs (id),
   quantity      INT            NOT NULL,
   refund_amount DECIMAL(18, 2) NULL
);

-- NOTE: 13. Audit / Log
CREATE TABLE dbo.audit_logs
(
   id          BIGINT IDENTITY (1,1) PRIMARY KEY,
   user_id     INT               NULL
      CONSTRAINT fk_audit_user REFERENCES dbo.users (id),
   action      NVARCHAR(200)     NOT NULL,
   entity_type NVARCHAR(100)     NULL,
   entity_id   NVARCHAR(100)     NULL,
   details     NVARCHAR(MAX)     NULL,
   created_at  DATETIMEOFFSET(7) NOT NULL DEFAULT SYSUTCDATETIME()
);

-- NOTE: 14. Konfiqurasiya / Sistem parametrləri
CREATE TABLE dbo.system_settings
(
   [key]       NVARCHAR(200) PRIMARY KEY,
   [value]     NVARCHAR(MAX) NULL,
   description NVARCHAR(MAX) NULL
);

