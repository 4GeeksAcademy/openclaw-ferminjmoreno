#!/bin/sh
# breathecode.sh — Librería de funciones para la API de BreatheCode
# POSIX-compliant (compatible con /bin/sh)
#
# Dependencias: curl, python3
# Uso: . /root/.openclaw/workspace/lib/breathecode.sh
# Luego: breathecode_api GET "/v1/admissions/user/me"

BREATHECODE_BASE="https://breathecode.herokuapp.com"
BREATHECODE_ENV="/root/.openclaw/workspace/.env"
BREATHECODE_CRED="/root/.openclaw/workspace/.env.credentials"

# Obtener el token actual de .env
_breathecode_get_token() {
    if [ -f "$BREATHECODE_ENV" ]; then
        grep "^TOKEN_4GEEKS=" "$BREATHECODE_ENV" | cut -d= -f2- | tr -d '"'
    fi
}

# Verificar si el token está activo consultando user/me
_breathecode_token_valido() {
    token="$1"
    [ -z "$token" ] && return 1

    resp=$(curl -s -o /dev/null -w "%{http_code}" \
        -X GET "$BREATHECODE_BASE/v1/auth/user/me" \
        -H "Authorization: Token $token" \
        -H "Accept: application/json" 2>&1)

    [ "$resp" = "200" ]
}

# Hacer login y refrescar el token en .env
_breathecode_refresh_token() {
    if [ ! -f "$BREATHECODE_CRED" ]; then
        echo "[breathecode] ERROR: No existe $BREATHECODE_CRED" >&2
        return 1
    fi

    email=$(grep "^EMAIL_4GEEKS=" "$BREATHECODE_CRED" | cut -d= -f2- | tr -d '"')
    password=$(grep "^PASSWORD_4GEEKS=" "$BREATHECODE_CRED" | cut -d= -f2- | tr -d '"')

    if [ -z "$email" ] || [ -z "$password" ]; then
        echo "[breathecode] ERROR: Credenciales incompletas en $BREATHECODE_CRED" >&2
        return 1
    fi

    echo "[breathecode] Token expirado. Renovando..." >&2
    resp=$(curl -s -X POST "$BREATHECODE_BASE/v1/auth/login/" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$email\",\"password\":\"$password\"}" 2>&1)

    token=$(echo "$resp" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('token', ''))
except:
    print('')
" 2>/dev/null)

    if [ -z "$token" ]; then
        echo "[breathecode] ERROR: No se pudo renovar token. Respuesta: $resp" >&2
        return 1
    fi

    echo "TOKEN_4GEEKS=$token" > "$BREATHECODE_ENV"
    echo "[breathecode] Token renovado exitosamente" >&2
    echo "$token"
    return 0
}

# breathecode_api — Llamada autenticada a la API
# Uso: breathecode_api GET "/v1/admissions/user/me"
#       breathecode_api POST "/v1/auth/login/" '{"email":"...","password":"..."}'
breathecode_api() {
    method="$1"
    endpoint="$2"
    data="$3"
    token=""

    token=$(_breathecode_get_token)

    if ! _breathecode_token_valido "$token"; then
        token=$(_breathecode_refresh_token)
        if [ $? -ne 0 ]; then
            return 1
        fi
    fi

    url="$BREATHECODE_BASE$endpoint"

    if [ -n "$data" ]; then
        curl -s -X "$method" "$url" \
            -H "Authorization: Token $token" \
            -H "Content-Type: application/json" \
            -H "Accept: application/json" \
            -d "$data"
    else
        curl -s -X "$method" "$url" \
            -H "Authorization: Token $token" \
            -H "Accept: application/json"
    fi
    return $?
}

# breathecode_api_json — Igual pero con JSON formateado
breathecode_api_json() {
    breathecode_api "$@" | python3 -m json.tool 2>/dev/null || breathecode_api "$@"
}

echo "[breathecode] Librería cargada."
echo "  breathecode_api <method> <endpoint> [data]"
echo "  breathecode_api_json <method> <endpoint> [data]"