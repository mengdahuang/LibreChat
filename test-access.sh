#!/bin/bash

echo "🔍 测试 LibreChat 访问性..."
echo "================================"

# 检查容器状态
echo "📦 检查容器状态:"
docker-compose ps

echo ""
echo "🌐 测试网络连接:"

# 测试端口是否开放
if nc -z localhost 3080 2>/dev/null; then
    echo "✅ 端口 3080 已开放"
else
    echo "❌ 端口 3080 无法访问"
fi

echo ""
echo "📄 测试页面访问:"

# 测试HTTP响应
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3080 2>/dev/null || echo "000")

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ LibreChat 页面可以访问 (HTTP $HTTP_STATUS)"
    echo "🔗 访问地址: http://localhost:3080"
elif [ "$HTTP_STATUS" = "000" ]; then
    echo "❌ 无法连接到 LibreChat"
else
    echo "⚠️  LibreChat 响应异常 (HTTP $HTTP_STATUS)"
fi

echo ""
echo "🎨 检查CSS文件:"
CSS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3080/disable-fork.css 2>/dev/null || echo "000")

if [ "$CSS_STATUS" = "200" ]; then
    echo "✅ 分叉禁用CSS文件可以访问"
else
    echo "❌ 分叉禁用CSS文件无法访问 (HTTP $CSS_STATUS)"
fi

echo ""
echo "📋 访问建议:"
echo "1. 在浏览器中访问: http://localhost:3080"
echo "2. 如果无法访问，请检查防火墙设置"
echo "3. 确认Docker容器正常运行"
echo "4. 检查是否有其他服务占用3080端口"

echo ""
echo "🔧 故障排除命令:"
echo "- 查看容器日志: docker-compose logs api"
echo "- 重启容器: docker-compose restart api"
echo "- 完全重新部署: docker-compose down && docker-compose up -d" 