#!/bin/bash

echo "🎨 测试 LibreChat Favicon 更新..."
echo "=================================="

# 检查新的favicon URL是否可访问
echo "🔗 测试中伦律师事务所 Favicon 源文件:"
FAVICON_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://www.zhonglun.com/upload/static/images/favicon.ico 2>/dev/null || echo "000")

if [ "$FAVICON_STATUS" = "200" ]; then
    echo "✅ 源favicon文件可以访问 (HTTP $FAVICON_STATUS)"
else
    echo "❌ 源favicon文件无法访问 (HTTP $FAVICON_STATUS)"
fi

echo ""
echo "🌐 测试 LibreChat 页面:"

# 测试LibreChat是否运行
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3080 2>/dev/null || echo "000")

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ LibreChat 页面正常运行"
    
    echo ""
    echo "🔍 检查页面中的 Favicon 配置:"
    
    # 下载页面HTML并检查favicon链接
    PAGE_CONTENT=$(curl -s http://localhost:3080 2>/dev/null)
    
    if echo "$PAGE_CONTENT" | grep -q "zhonglun.com.*favicon.ico"; then
        echo "✅ 页面HTML包含中伦律师事务所favicon链接"
        
        # 显示找到的favicon链接
        echo ""
        echo "📋 找到的 Favicon 链接:"
        echo "$PAGE_CONTENT" | grep -o 'href="[^"]*zhonglun.com[^"]*favicon.ico[^"]*"' | head -5
        
    else
        echo "❌ 页面HTML未找到中伦律师事务所favicon链接"
        echo "⚠️  可能需要清除浏览器缓存或硬刷新"
    fi
    
    echo ""
    echo "🧹 浏览器验证建议:"
    echo "1. 在浏览器中访问: http://localhost:3080"
    echo "2. 硬刷新页面: Ctrl+F5 (Windows) 或 Cmd+Shift+R (Mac)"
    echo "3. 清除浏览器缓存"
    echo "4. 检查浏览器标签页的图标是否已更新"
    echo "5. 右键点击页面 -> 查看源代码，搜索 'favicon'"
    
else
    echo "❌ LibreChat 页面无法访问 (HTTP $HTTP_STATUS)"
fi

echo ""
echo "📁 文件信息:"
echo "- 新 Favicon URL: https://www.zhonglun.com/upload/static/images/favicon.ico"
echo "- 图片格式: PNG (144x144像素)"
echo "- 自定义配置文件: custom/index.html"

echo ""
echo "🔄 如果favicon未更新:"
echo "1. 清除浏览器缓存: Ctrl+Shift+Del"
echo "2. 硬刷新: Ctrl+F5 或 Cmd+Shift+R"
echo "3. 重启容器: docker-compose restart api"
echo "4. 等待几分钟让DNS缓存更新" 