# 1. 加载空间数据工具
library(sf)

# 2. 选择地图边界：选 .shp 文件
nz_shape <- st_read(file.choose())

# 3. 选择就业统计表：选 nz_paid_employee_2018.csv
nz_jobs <- read.csv(file.choose(), colClasses = "character",
                    check.names = FALSE)

# 4. 删除总计和空行，把人数转换为数值
nz_jobs <- nz_jobs[grepl("^[0-9]{3}$", nz_jobs$TA_CODE), ]
nz_jobs$paid_employee_2018 <- as.numeric(nz_jobs$paid_employee_2018)

# 5. 按地区代码连接
idx <- match(nz_shape$TA2018_V1_, nz_jobs$TA_CODE)
nz_shape$paid_employee_2018 <- nz_jobs$paid_employee_2018[idx]

# 6. 检查未匹配数量：应为 0
sum(is.na(idx))

# 7. 绘制就业人数地图
plot(nz_shape["paid_employee_2018"], main = "Paid employees, 2018")
st_write(nz_shape, "nz_employment_2018.gpkg", layer = "employment_2018", delete_layer = TRUE)