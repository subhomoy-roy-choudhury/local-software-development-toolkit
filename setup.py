from setuptools import setup
import pathlib

DESCRIPTION = "This is a tool to create local mongo servers"
# The directory containing this file
HERE = pathlib.Path(__file__).parent

# The text of the README file
README = (HERE / "README.md").read_text()

setup(
    name="Local Mongo DB",
    version="0.0.1",
    description= DESCRIPTION,
    long_description = README,
    long_description_content_type="text/markdown",
    author="Subhomoy Roy Choudhury",
    author_email = "subhomoyrchoudhury@gmail.com",
    url="https://github.com/subhomoy-roy-choudhury/mongo-local-db-setup",
    license="MIT",
    classifiers=[
            "License :: OSI Approved :: MIT License",
            "Programming Language :: Python :: 3",
            "Programming Language :: Python :: 3.7",
            "Programming Language :: Python :: 3.8",
        ],
    packages=['local_mongo'],
    include_package_data=True,
    install_requires=[],
    entry_points={
        "console_scripts": [
            "local-mongo=local_mongo.main:run",
        ]
    },
)