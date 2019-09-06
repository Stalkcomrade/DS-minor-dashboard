## resotre
packrat::restore()

## tell where to look for new dependencies
packrat::init(infer.dependencies = FALSE,
              options = list(
                vcs.ignore.lib = TRUE,
                vcs.ignore.src = TRUE
              ))