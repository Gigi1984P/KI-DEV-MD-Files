# Authentication Anti-Patterns

## 1. Storing Passwords in Plain Text

```javascript
// ❌ NEVER DO THIS
const user = await db.users.create({
  email,
  password: req.body.password // Plain text!
});
```

**Why it fails:** Database breach = immediate credential compromise.

**Fix:** Use bcrypt, Argon2, or PBKDF2 with salt.

## 2. JWT Without Expiration

```javascript
// ❌ NEVER DO THIS
const token = jwt.sign({ userId: user.id }, SECRET);
// No expiration — valid forever
```

**Why it fails:** Stolen token never expires. Attacker has permanent access.

**Fix:** Set `expiresIn: '15m'` and use refresh tokens.

## 3. Storing Tokens in localStorage

```javascript
// ❌ NEVER DO THIS
localStorage.setItem('token', jwt);
```

**Why it fails:** XSS attack can steal token.

**Fix:** Use httpOnly, Secure, SameSite=Strict cookies.

## 4. No Rate Limiting

```javascript
// ❌ NEVER DO THIS
app.post('/login', (req, res) => {
  // No rate limit — brute force possible
});
```

**Why it fails:** Automated attacks can try millions of passwords.

**Fix:** Implement IP-based and user-based rate limiting.

## 5. Missing CSRF Protection

```javascript
// ❌ NEVER DO THIS
fetch('/api/transfer', {
  method: 'POST',
  body: JSON.stringify({ to: 'attacker', amount: 10000 })
});
```

**Why it fails:** Attacker can forge requests from user's browser.

**Fix:** Use CSRF tokens for state-changing operations.

## 6. Weak Password Policies

```javascript
// ❌ NEVER DO THIS
if (password.length < 6) {
  throw new Error('Password too short');
}
```

**Why it fails:** `Password1` passes but is easily cracked.

**Fix:** Use zxcvbn or similar strength checker. Check against breach databases.

## 7. No HTTPS

```javascript
// ❌ NEVER DO THIS
http.createServer(app); // Plain HTTP
```

**Why it fails:** Credentials and tokens transmitted in plaintext.

**Fix:** Always use HTTPS with proper TLS configuration.

## 8. Hardcoded Secrets

```javascript
// ❌ NEVER DO THIS
const SECRET = 'my-secret-key-123'; // In source code
```

**Why it fails:** Secret exposed in version control.

**Fix:** Use environment variables or secret management (AWS Secrets Manager, Vault).


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-authentication/` — Build recipes
- `09-boilerplates/authentication/` — Starter templates
