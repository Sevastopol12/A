
--Add Partition
CREATE OR REPLACE FUNCTION AddPartition (
    table_name       IN VARCHAR2,  -- Table name
    partition_name   IN VARCHAR2,  -- Name of the partition
    partition_type   IN VARCHAR2,  -- Type of partition: 'RANGE', 'LIST'
    partition_value  IN VARCHAR2   -- Values for the partition (e.g., range or list)
) RETURN VARCHAR2 AS
    sql_stmt VARCHAR2(100);
BEGIN
    -- Handle different partition types
    IF UPPER(partition_type) = 'RANGE' THEN
        -- RANGE PARTITION
        sql_stmt := 'ALTER TABLE ' || table_name || 
                    ' ADD PARTITION ' || partition_name || 
                    ' VALUES LESS THAN (TO_DATE(''' || partition_value || ''', ''YYYY-MM-DD''))';

    ELSIF UPPER(partition_type) = 'LIST' THEN
        -- LIST PARTITION
        sql_stmt := 'ALTER TABLE ' || table_name || 
                    ' ADD PARTITION ' || partition_name || 
                    ' VALUES (' || partition_value || ')';

    ELSE
        -- Unsupported partition type
        RETURN 'Error: Unsupported partition type "' || partition_type || '". Supported types are RANGE and LIST.';
    END IF;

    EXECUTE IMMEDIATE sql_stmt;

    RETURN 'Partition ' || partition_name || ' added successfully to table ' || table_name;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
/

-- Drop PARTITION
CREATE OR REPLACE FUNCTION DropPartition (
    table_name       IN VARCHAR2,  -- Table name
    partition_name   IN VARCHAR2   -- Partition name to be dropped
) RETURN VARCHAR2 AS
    sql_stmt VARCHAR2(100);
BEGIN
    sql_stmt := 'ALTER TABLE ' || table_name || 
                ' DROP PARTITION ' || partition_name;

    EXECUTE IMMEDIATE sql_stmt;

    RETURN 'Partition ' || partition_name || ' dropped successfully from table ' || table_name;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
/


-- Merge PARITIONS
CREATE OR REPLACE FUNCTION MergePartitions (
    table_name       IN VARCHAR2,  -- Name of the partitioned table
    partitions_to_merge IN VARCHAR2,  -- Comma-separated list of partition names to merge
    new_partition_name IN VARCHAR2  -- Name of the resulting merged partition
) RETURN VARCHAR2 AS
    sql_stmt VARCHAR2(100);
BEGIN
    sql_stmt := 'ALTER TABLE ' || table_name || 
                ' MERGE PARTITIONS ' || partitions_to_merge || 
                ' INTO PARTITION ' || new_partition_name;

    EXECUTE IMMEDIATE sql_stmt;

    RETURN 'Partitions (' || partitions_to_merge || ') merged successfully into ' || new_partition_name;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
/


--Split PARTITION
CREATE OR REPLACE FUNCTION SplitPartition (
    table_name        IN VARCHAR2,  -- Name of the partitioned table
    partition_to_split IN VARCHAR2, -- Name of the partition to split
    split_point       IN DATE,      -- The value where the partition is split
    new_partition1    IN VARCHAR2,  -- Name for the first resulting partition
    new_partition2    IN VARCHAR2   -- Name for the second resulting partition
) RETURN VARCHAR2 AS
    sql_stmt VARCHAR2(1000);
BEGIN
    sql_stmt := 'ALTER TABLE ' || table_name || 
                ' SPLIT PARTITION ' || partition_to_split || 
                ' AT (TO_DATE(''' || TO_CHAR(split_point, 'YYYY-MM-DD') || ''', ''YYYY-MM-DD'')) ' || 
                ' INTO (PARTITION ' || new_partition1 || ', PARTITION ' || new_partition2 || ')';

    EXECUTE IMMEDIATE sql_stmt;

    RETURN 'Partition ' || partition_to_split || 
           ' split successfully into ' || new_partition1 || ' and ' || new_partition2;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
/



