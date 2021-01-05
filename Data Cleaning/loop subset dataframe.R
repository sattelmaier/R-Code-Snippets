library(randomNames)

## dataframe 
type = c('B', 'A', 'C', 'D', 'A', 'C', 'B', 'D')
num = rnorm(mean = 0, sd = 1, n = 8)
name = randomNames(8)

df <- data.frame(type, num, name, stringsAsFactors=FALSE)

## create factor
factor <- as.factor(type)

# create sub datasets using loop - Bad coding
for (i in factor){
 assign(paste("group", i, sep = "_"), df[df$type == i, c('num', 'name')])
}

# Using Split and list2env
df_list <- split(df, df$type) # sorts lists automatically by factor; important for subsetting, but inconvenient 
df_A = as.data.frame(df_list[1]) 

# One line
list2env(df_list, envir = .GlobalEnv) #named according to factor
list2env(setNames(df_list, paste0('group', names(df_list))), envir = .GlobalEnv)

