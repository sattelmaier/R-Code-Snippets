library(randomNames)

## Create dataframe 
type = c('B', 'A', 'C', 'D', 'A', 'C', 'B', 'D')
num = rnorm(mean = 0, sd = 1, n = 8)
name = randomNames(8)

df <- data.frame(type, num, name, stringsAsFactors=FALSE)

factor <- as.factor(type) # create factor

## Three Alternatives

### 1) create sub datasets using loop - But bad coding
for (i in factor){
 assign(paste("group", i, sep = "_"), df[df$type == i, c('num', 'name')])
}

### 2) Using Split and list2env
df_list <- split(df, df$type) # sorts lists automatically by factor; important for subsetting, but inconvenient 
df_A = as.data.frame(df_list[1]) 

### 3) One line 
# 3.1) data frames named according to factor 
list2env(df_list, envir = .GlobalEnv)
# 3.2) edit data frame names
list2env(setNames(df_list, paste0('group', names(df_list))), envir = .GlobalEnv)
