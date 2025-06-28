from sqlalchemy import Table, Column, String, Integer, MetaData

metadata = MetaData()

aggregates = Table(
    "aggregates",
    metadata,
    Column("worker_id", String, primary_key=True),
    Column("keystrokes", Integer, nullable=False),
)
