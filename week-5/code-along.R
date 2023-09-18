# First dataset ("left")
band_members

# Second dataset ("right")
band_instruments

# Inner join - guess which rows will remain!
band_members %>% 
    inner_join(band_instruments)

# Left join - guess which rows will remain!
band_members %>% 
    left_join(band_instruments)

# New second dataset ("right")
band_instruments2

# Full join with different keys
band_members %>% 
    full_join(band_instruments2, by = join_by(name == artist))

# What if the Paul in instruments is from another band?
band_instruments <- 
    band_instruments %>% 
    mutate(band = c("Beatles", "Porcupines", "Stones")) 

# We can then join on both name *and* band
band_members %>% 
    left_join(band_instruments, by = join_by(name, band))

