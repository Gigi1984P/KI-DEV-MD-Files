# Laravel Multilang Installation

## Übersicht

Komplettes mehrsprachiges System für plantone.de (DE/EN/IT) mit Laravel-Integration.

## 📦 Paket-Inhalt

```
laravel-multilang-package/
├── composer.json           # Composer-Definition
├── config/
│   └── multilang.php       # Konfiguration
├── src/
│   ├── MultilangServiceProvider.php
│   └── Http/
│       └── Middleware/
│           └── SetLocale.php
├── resources/
│   ├── lang/               # Übersetzungsdateien
│   │   ├── de.json
│   │   ├── en.json
│   │   └── it.json
│   └── views/
│       └── components/
│           └── language-switcher.blade.php
└── install.sh              # Installationsskript
```

## 🚀 Installation

### Schritt 1: Paket hochladen

```bash
# Entpacke das Paket in dein Laravel-Projekt
cd /home/plantoa/public_html/homepage
tar xzvf laravel-multilang-package.tar.gz
```

### Schritt 2: ServiceProvider registrieren

Füge in `config/app.php` unter `providers` hinzu:

```php
'providers' => [
    // ... andere Provider
    Plantone\Multilang\MultilangServiceProvider::class,
],
```

### Schritt 3: Middleware registrieren

Füge in `app/Http/Kernel.php` hinzu:

```php
protected $middlewareGroups = [
    'web' => [
        // ... andere Middleware
        \Plantone\Multilang\Http\Middleware\SetLocale::class,
    ],
];
```

### Schritt 4: Assets veröffentlichen

```bash
php artisan vendor:publish --tag=multilang-translations
php artisan vendor:publish --tag=multilang-config
php artisan vendor:publish --tag=multilang-views
```

## 📝 Verwendung in Blade-Templates

### Übersetzungen

```blade
{{-- Vorher --}}
<h1>Mehr Produktivitaet.</h1>

{{-- Nachher --}}
<h1>{{ __('heroTitle1') }}</h1>

{{-- Alternative --}}
<h1>@lang('heroTitle1')</h1>
```

### Language Switcher

```blade
{{-- Im Header/Nav --}}
<nav>
    <a href="/leistungen">{{ __('navServices') }}</a>
    <a href="/ueber">{{ __('navAbout') }}</a>
    
    {{-- Language Switcher Component --}}
    <x-multilang::language-switcher />
</nav>
```

### Meta-Tags

```blade
<head>
    <title>{{ __('metaTitle') }}</title>
    <meta name="description" content="{{ __('metaDescription') }}">
    
    {{-- hreflang Tags für SEO --}}
    <link rel="alternate" hreflang="de" href="{{ url('/') }}" />
    <link rel="alternate" hreflang="en" href="{{ url('/?lang=en') }}" />
    <link rel="alternate" hreflang="it" href="{{ url('/?lang=it') }}" />
</head>
```

## 🎨 Language Switcher CSS

Füge zu deinem CSS hinzu:

```css
.lang-switcher-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 8px 16px;
    border-radius: 8px;
    border: 1px solid rgba(148, 163, 184, 0.3);
    background: rgba(30, 41, 59, 0.6);
    color: #cbd5e1;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
}

.lang-switcher-btn:hover {
    border-color: #3ECF8E;
    color: #3ECF8E;
    background: rgba(62, 207, 142, 0.1);
}
```

## 🔧 Backend-Bearbeitung der Übersetzungen

### Option 1: Direkte JSON-Bearbeitung

Die Dateien liegen in:
```
resources/lang/de.json
resources/lang/en.json
resources/lang/it.json
```

Einfach auf dem Server bearbeiten oder herunterladen, bearbeiten, hochladen.

### Option 2: Über Laravel Artisan

```bash
# Cache leeren nach Änderungen
php artisan cache:clear
php artisan config:clear

# Translations neu laden
php artisan optimize:clear
```

### Option 3: Admin-Panel (zukünftig)

Du kannst ein einfaches Admin-Panel erstellen:

```php
// routes/web.php
Route::middleware(['auth'])->prefix('admin')->group(function () {
    Route::get('/translations', [TranslationController::class, 'index']);
    Route::post('/translations', [TranslationController::class, 'update']);
});
```

## 🌍 Sprachwechsel-Logik

Die Middleware erkennt automatisch:
1. **URL Parameter**: `?lang=en`
2. **Cookie**: Gespeicherte Präferenz
3. **Session**: Aktive Session
4. **Browser**: HTTP_ACCEPT_LANGUAGE Header

## 📝 Beispiel: Komplette Seite

```blade
<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
    <meta charset="UTF-8">
    <title>{{ __('metaTitle') }}</title>
    <meta name="description" content="{{ __('metaDescription') }}">
</head>
<body>
    <header>
        <nav>
            <a href="/leistungen">{{ __('navServices') }}</a>
            <a href="/ueber">{{ __('navAbout') }}</a>
            <a href="/blog">{{ __('navBlog') }}</a>
            <a href="/faq">{{ __('navFAQ') }}</a>
            <a href="/kontakt">{{ __('navContact') }}</a>
            
            <x-multilang::language-switcher />
        </nav>
    </header>
    
    <main>
        <section class="hero">
            <h1>{{ __('heroTitle1') }}</h1>
            <p>{{ __('heroDesc1') }}</p>
            <a href="/termin-buchen" class="cta">
                {{ __('heroCTA1') }}
            </a>
        </section>
        
        <section class="results">
            <h2>{{ __('resultsTitle') }}</h2>
            <div class="stats">
                <div class="stat">
                    <span>30%</span>
                    <span>{{ __('stat1Label') }}</span>
                </div>
            </div>
        </section>
    </main>
    
    <footer>
        <p>{{ __('footerCopyright') }}</p>
    </footer>
</body>
</html>
```

## 🎯 SEO

### hreflang Tags

```blade
<link rel="alternate" hreflang="de" href="https://plantone.de/" />
<link rel="alternate" hreflang="en" href="https://plantone.de/?lang=en" />
<link rel="alternate" hreflang="it" href="https://plantone.de/?lang=it" />
<link rel="alternate" hreflang="x-default" href="https://plantone.de/" />
```

### Sitemap.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">
    <url>
        <loc>https://plantone.de/</loc>
        <xhtml:link rel="alternate" hreflang="de" href="https://plantone.de/" />
        <xhtml:link rel="alternate" hreflang="en" href="https://plantone.de/?lang=en" />
        <xhtml:link rel="alternate" hreflang="it" href="https://plantone.de/?lang=it" />
    </url>
</urlset>
```

## ❓ Support

Bei Fragen oder Problemen:
1. Prüfe Laravel Logs: `storage/logs/laravel.log`
2. Cache leeren: `php artisan cache:clear`
3. Konfiguration prüfen: `config/multilang.php`

## 📄 Lizenz

© 2026 Gianluigi Plantone. Alle Rechte vorbehalten.
