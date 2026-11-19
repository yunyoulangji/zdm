SmzdmRemind 1.1.8.8 - GitHub Actions 编译说明

这次更新主要修复 GitHub Actions 构建流程，不代表 C++ 编译错误已经被验证解决。

更新点：
1. actions/checkout 升级为 v7，microsoft/setup-msbuild 升级为 v3，actions/upload-artifact 升级为 v7，适配 Node.js 24 运行时。
2. 编译命令会输出详细的 msbuild.log 和 msbuild.binlog。
3. 成品使用明确的 ZIP 文件路径上传，避免把多个通配符写在同一行导致路径匹配失败。
4. 编译结束后检查 EXE 和 DLL 是否为 Windows x64 (AMD64)。
5. 不论构建成功还是失败，都会尝试上传 MSBuild-Diagnostics 日志工件。

如何使用：
1. 将本目录内的文件上传到 GitHub 仓库根目录，并覆盖同名文件。
2. 确认 .github/workflows/build-windows.yml 已被覆盖。
3. 打开 GitHub 仓库的 Actions。
4. 左边选中 “SmzdmRemind Windows x64（诊断构建）”。
5. 点击 Run workflow，再点击绿色 Run workflow。
6. 如果失败，打开该次运行页面的 Artifacts，下载 MSBuild-Diagnostics.zip，并把里面的 msbuild.log 发给协助你排错的人。

重要：
- Node.js 20 deprecation 是 Actions 运行环境弃用警告，不是 C++ 编译错误本身。
- “No files were found...” 一般是前面没有生成 EXE，或上传路径写错导致的后续问题。
- 如果 MSBuild 仍然退出代码 1，必须根据 msbuild.log 中第一条 Cxxxx、LNKxxxx 或 MSBxxxx 错误修复源代码/项目配置。
