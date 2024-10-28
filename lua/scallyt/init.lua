require("scallyt.set")
require("scallyt.remap")
require("scallyt.lazy_init")
require("scallyt.color")
local jdtls = require("jdtls")

local mason_registry = require("mason-registry")
local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"

local config = {
    cmd = {
        vim.fn.exepath("jdtls"),
        string.format("--jvm-arg=-javaagent:%s", lombok_jar),
    },
    root_dir = vim.fn.getcwd(),
}

jdtls.start_or_attach(config)
