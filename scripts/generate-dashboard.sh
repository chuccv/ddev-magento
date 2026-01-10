#!/bin/bash

OUTPUT_FILE="ddev-projects.html"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cat > "$OUTPUT_FILE" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDEV Projects Dashboard</title>
    <meta http-equiv="refresh" content="5">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 {
            color: white;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        .info {
            background: rgba(255,255,255,0.9);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            color: #666;
        }
        .projects-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 20px;
        }
        .project-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .project-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .project-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e5e7eb;
        }
        .project-name {
            font-size: 1.5em;
            font-weight: bold;
            color: #333;
        }
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
        }
        .status-running { background: #10b981; color: white; }
        .status-stopped { background: #ef4444; color: white; }
        .status-error { background: #f59e0b; color: white; }
        .status-config { background: #6b7280; color: white; }
        .project-info { margin-top: 15px; }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { color: #6b7280; font-weight: 500; }
        .info-value {
            color: #111827;
            word-break: break-all;
            text-align: right;
        }
        .info-value a {
            color: #667eea;
            text-decoration: none;
        }
        .info-value a:hover { text-decoration: underline; }
        .ports-section {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #e5e7eb;
        }
        .ports-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
            font-size: 1.1em;
        }
        .port-group {
            margin-bottom: 8px;
        }
        .port-service {
            color: #6b7280;
            font-weight: 600;
            font-size: 0.9em;
            margin-top: 5px;
        }
        .port-item {
            font-size: 0.85em;
            padding: 3px 0;
            margin-left: 10px;
        }
        .port-number {
            font-family: 'Courier New', monospace;
            color: #667eea;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 DDEV Projects Dashboard</h1>
        <div class="info">
            Auto-refresh every 5 seconds | Last updated: <span id="timestamp"></span>
        </div>
        <div class="projects-grid">
EOF

ddev list -j 2>/dev/null | python3 -c "
import sys
import json
import subprocess
import re

def get_port_info(project_name):
    try:
        result = subprocess.run(
            ['ddev', 'describe', project_name, '-j'],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode != 0:
            return None
        
        output = result.stdout
        json_start = output.find('{\"level\"')
        if json_start == -1:
            return None
        
        json_string = output[json_start:]
        json_end = json_string.rfind('}')
        if json_end == -1:
            return None
        
        json_string = json_string[:json_end + 1]
        data = json.loads(json_string)
        return data.get('raw', {})
    except:
        return None

def format_port_mapping(mapping):
    if not mapping:
        return []
    ports = []
    for item in mapping:
        exposed = item.get('exposed_port', '')
        host = item.get('host_port', '')
        if exposed and host:
            ports.append(f'{exposed}→{host}')
    return ports

try:
    data = json.load(sys.stdin)
    if 'raw' in data:
        projects = data['raw']
        for p in projects:
            name = p.get('name', 'Unknown')
            status = p.get('status', 'unknown')
            status_class = 'error'
            if 'running' in status.lower() or status == 'ok':
                status_class = 'running'
            elif 'stopped' in status.lower():
                status_class = 'stopped'
            elif 'missing' in status.lower() or 'error' in status.lower():
                status_class = 'error'
            else:
                status_class = 'config'
            
            type_val = p.get('type', 'N/A')
            location = p.get('shortroot', p.get('approot', 'N/A'))
            primary_url = p.get('primary_url', '')
            https_url = p.get('httpsurl', '')
            http_url = p.get('httpurl', '')
            mailpit_url = p.get('mailpit_https_url', p.get('mailpit_url', ''))
            
            print(f'            <div class=\"project-card\">')
            print(f'                <div class=\"project-header\">')
            print(f'                    <div class=\"project-name\">{name}</div>')
            print(f'                    <span class=\"status-badge status-{status_class}\">{status}</span>')
            print(f'                </div>')
            print(f'                <div class=\"project-info\">')
            print(f'                    <div class=\"info-row\"><span class=\"info-label\">Type:</span><span class=\"info-value\">{type_val}</span></div>')
            print(f'                    <div class=\"info-row\"><span class=\"info-label\">Location:</span><span class=\"info-value\">{location}</span></div>')
            if primary_url:
                print(f'                    <div class=\"info-row\"><span class=\"info-label\">Primary URL:</span><span class=\"info-value\"><a href=\"{primary_url}\" target=\"_blank\">{primary_url}</a></span></div>')
            if https_url:
                print(f'                    <div class=\"info-row\"><span class=\"info-label\">HTTPS:</span><span class=\"info-value\"><a href=\"{https_url}\" target=\"_blank\">{https_url}</a></span></div>')
            if http_url:
                print(f'                    <div class=\"info-row\"><span class=\"info-label\">HTTP:</span><span class=\"info-value\"><a href=\"{http_url}\" target=\"_blank\">{http_url}</a></span></div>')
            if mailpit_url:
                print(f'                    <div class=\"info-row\"><span class=\"info-label\">Mailpit:</span><span class=\"info-value\"><a href=\"{mailpit_url}\" target=\"_blank\">Open Mailpit</a></span></div>')
            
            if status_class == 'running':
                describe_data = get_port_info(name)
                if describe_data and 'services' in describe_data:
                    print(f'                    <div class=\"ports-section\">')
                    print(f'                        <div class=\"ports-title\">Ports:</div>')
                    services = describe_data['services']
                    service_order = ['web', 'db', 'redis', 'opensearch', 'elasticsearch', 'rabbitmq', 'varnish', 'mailpit', 'xhgui']
                    
                    for service_name in service_order:
                        if service_name in services:
                            service = services[service_name]
                            service_status = service.get('status', '')
                            if service_status == 'stopped':
                                continue
                            
                            mapping = service.get('host_ports_mapping', [])
                            if mapping:
                                ports = format_port_mapping(mapping)
                                if ports:
                                    print(f'                        <div class=\"port-group\">')
                                    print(f'                            <div class=\"port-service\">{service_name.upper()}:</div>')
                                    for port_str in ports:
                                        parts = port_str.split('→')
                                        if len(parts) == 2:
                                            exposed, host = parts
                                            print(f'                            <div class=\"port-item\"><span class=\"port-number\">{exposed}</span> → <span class=\"port-number\">127.0.0.1:{host}</span></div>')
                                    print(f'                        </div>')
                    
                    for service_name, service in services.items():
                        if service_name not in service_order:
                            service_status = service.get('status', '')
                            if service_status == 'stopped':
                                continue
                            mapping = service.get('host_ports_mapping', [])
                            if mapping:
                                ports = format_port_mapping(mapping)
                                if ports:
                                    print(f'                        <div class=\"port-group\">')
                                    print(f'                            <div class=\"port-service\">{service_name.upper()}:</div>')
                                    for port_str in ports:
                                        parts = port_str.split('→')
                                        if len(parts) == 2:
                                            exposed, host = parts
                                            print(f'                            <div class=\"port-item\"><span class=\"port-number\">{exposed}</span> → <span class=\"port-number\">127.0.0.1:{host}</span></div>')
                                    print(f'                        </div>')
                    
                    if 'dbinfo' in describe_data:
                        dbinfo = describe_data['dbinfo']
                        db_host = dbinfo.get('host', 'db')
                        db_port = dbinfo.get('published_port', dbinfo.get('dbPort', '3306'))
                        db_name = dbinfo.get('dbname', 'db')
                        db_user = dbinfo.get('username', 'db')
                        print(f'                        <div class=\"port-group\">')
                        print(f'                            <div class=\"port-service\">DATABASE INFO:</div>')
                        print(f'                            <div class=\"port-item\">Host: <span class=\"port-number\">{db_host}</span> | Port: <span class=\"port-number\">{db_port}</span></div>')
                        print(f'                            <div class=\"port-item\">DB: <span class=\"port-number\">{db_name}</span> | User: <span class=\"port-number\">{db_user}</span></div>')
                        print(f'                        </div>')
                    
                    print(f'                    </div>')
            
            print(f'                </div>')
            print(f'            </div>')
    else:
        print('            <div class=\"project-card\"><p>No projects found</p></div>')
except Exception as e:
    print(f'            <div class=\"project-card\"><p>Error: {str(e)}</p></div>')
" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'EOF'
        </div>
    </div>
    <script>
        document.getElementById('timestamp').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
EOF

echo "✅ Dashboard generated: $OUTPUT_FILE"
echo "📂 Open in browser: file://$(realpath "$OUTPUT_FILE")"
echo "🌐 Or serve with: python3 -m http.server 8888"
