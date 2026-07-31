# Plantone Website

Laravel-Seitengeruest fuer die Website von Gianluigi Plantone.

## Lokal starten

PHP und Composer sind in dieser Umgebung aktuell nicht installiert. Sobald sie verfuegbar sind:

```bash
composer install
cp .env.example .env
php artisan key:generate
npm install
npm run build
php artisan serve
```

Die wichtigsten Dateien liegen in:

- `routes/web.php`
- `config/site.php`
- `resources/views/pages`
- `resources/views/components`
