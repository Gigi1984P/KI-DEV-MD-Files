# Technik-Blueprint für die erste Website-Version

## Stack

- PHP 8.4+
- Laravel 13
- Blade
- Tailwind CSS
- Alpine.js sparsam
- serverseitige Formularverarbeitung
- keine Datenbank in Phase 1

## Komponenten

- HeroSection
- ProblemSection
- ResultsSection
- ServicesSection
- ProcessSection
- TrustSection
- CaseStudiesSection
- FaqSection
- ContactSection
- FooterCta

## Sicherheit

- strict_types in PHP-Dateien
- CSRF-Schutz für Formulare
- serverseitige Validierung
- Output Escaping über Blade
- Honeypot oder Rate-Limit als Spam-Schutz
- Security Headers auf Webserver- oder App-Ebene
- HTTPS erzwingen
- Debug-Modus aus in Produktion
- keine Secrets im Repository

## SEO

- Meta-Titel pro Seite
- Meta-Description pro Seite
- Canonical URLs
- OpenGraph Tags
- sitemap.xml
- robots.txt
- JSON-LD für Organization, WebSite, FAQPage

## Performance

- Tailwind nur mit genutzten Klassen builden
- minimale JS-Nutzung
- komprimierte Bilder
- Font-Strategie schlank halten
- Caching-Headers vorbereiten

## Deployment-Prinzip

Vor jedem Deployment:
1. Backup ziehen
2. bestehende Dateien sichern
3. Rollback-Pfad dokumentieren
4. Syntax prüfen
5. Build validieren
6. Sicherheitscheck machen
7. dann deployen

## Phase-1-Lieferumfang

- vollständige Startseite
- Leistungsseite
- Über-Seite
- FAQ-Seite
- Kontaktseite mit Formular
- Impressum
- Datenschutz
- SEO-Grundlagen
- Analytics/Cookie-Vorbereitung

## Phase-2-Optionen

- CMS oder einfache Inhaltsverwaltung
- CRM-Anbindung
- Terminbuchungsintegration
- mehrsprachige Seiten
- Case-Study-Verwaltung
- Lead-Scoring
